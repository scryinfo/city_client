namespace City
{
    using System;
    using System.Net.Sockets;
    using System.Net;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Runtime.Remoting.Messaging;

    using MessageID = System.UInt16;
    using MessageLength = System.UInt16;

    /*
		Packet receiving module (corresponding to the name of the server network part)
        Handle network data reception
	*/

    public class PacketReceiver
    {

        public delegate void AsyncReceiveMethod();

        private NetworkInterface _networkInterface = null;

        private byte[] _buffer;

        // The starting position where the socket writes to the buffer
        int _wpos = 0;

        // The starting position of the main thread to read data
        int _rpos = 0;

        public PacketReceiver(NetworkInterface networkInterface)
        {
            _init(networkInterface);
        }

        ~PacketReceiver()
        {
            Dbg.DEBUG_MSG("PacketReceiver::~PacketReceiver(), destroyed!");
        }

        void _init(NetworkInterface networkInterface)
        {
            _networkInterface = networkInterface;
            _buffer = new byte[NetworkInterface.TCP_PACKET_MAX];

        }

        public NetworkInterface networkInterface()
        {
            return _networkInterface;
        }

        public void process()
        {
            int t_wpos = Interlocked.Add(ref _wpos, 0);
                        
            if (_rpos < t_wpos) //If the data written in _buffer is greater than the read data, then the newly added data is forwarded to lua for analysis
            {   //Buffer the situation where the remaining space on the right is sufficient
                CityLuaUtil.CallMethod("CityEngineLua.MessageReader", "process", new object[] { _buffer, (UInt32)_rpos, (UInt32)(t_wpos - _rpos) });
                Interlocked.Exchange(ref _rpos, t_wpos);
            }
            else if (t_wpos < _rpos)
            {  //If the remaining space on the right side of the buffer is insufficient, _rpos is greater than t_wpos
                CityLuaUtil.CallMethod("CityEngineLua.MessageReader", "process", new object[] { _buffer, (UInt32)_rpos, (UInt32)(_buffer.Length - _rpos) });
                CityLuaUtil.CallMethod("CityEngineLua.MessageReader", "process", new object[] { _buffer, (UInt32)0, (UInt32)t_wpos });
                Interlocked.Exchange(ref _rpos, t_wpos);
            }
            else
            {
                // No readable data
            }
        }

        int _free()
        {
            int t_rpos = Interlocked.Add(ref _rpos, 0);

            if (_wpos == _buffer.Length)
            {
                if (t_rpos == 0)
                {
                    return 0;
                }

                Interlocked.Exchange(ref _wpos, 0);
            }

            if (t_rpos <= _wpos)
            {
                return _buffer.Length - _wpos;
            }

            return t_rpos - _wpos - 1;
        }

        public void startRecv()
        {

            var v = new AsyncReceiveMethod(this._asyncReceive);
            v.BeginInvoke(new AsyncCallback(_onRecv), null);
        }

        private void _asyncReceive()
        {
            if (_networkInterface == null || !_networkInterface.valid())
            {
                Dbg.WARNING_MSG("PacketReceiver::_asyncReceive(): network interface invalid!");
                return;
            }

            var socket = _networkInterface.sock();

            while (true)
            {
                // There must be space to write, otherwise we block in the thread until there is space
                int first = 0;
                int space = _free();

                while (space == 0)
                {
                    if (first > 0)
                    {
                        if (first > 1000)
                        {
                            Dbg.ERROR_MSG("PacketReceiver::_asyncReceive(): no space!");
                            Event.fireIn("_closeNetwork", new object[] { _networkInterface });
                            return;
                        }

                        Dbg.WARNING_MSG("PacketReceiver::_asyncReceive(): waiting for space, Please adjust 'RECV_BUFFER_MAX'! retries=" + first);
                        System.Threading.Thread.Sleep(5);
                    }

                    first += 1;
                    space = _free();
                }

                int bytesRead = 0;
                try
                {
                    bytesRead = socket.Receive(_buffer, _wpos, space, 0);
                }
                catch (SocketException se)
                {
                    _networkInterface._sysEvent = City.SYSEVENT.SYSEVENT_DISCONNECT;
                    Dbg.WARNING_MSG(string.Format("PacketReceiver::_asyncReceive(): receive error, disconnect from '{0}'! error = '{1}'", socket.RemoteEndPoint, se));
                    _networkInterface._ConnectState.error = se.Message;
                    Event.fireIn("_closeNetwork", new object[] { _networkInterface });
                    return;
                }

                if (bytesRead > 0)
                {
                    // Update write location
                    Interlocked.Add(ref _wpos, bytesRead);
                    if (bytesRead >= NetworkInterface.TCP_PACKET_MAX)
                    {
                        Dbg.ERROR_MSG(string.Format("[PacketReceiver::_asyncReceive]: bytesRead >= NetworkInterface.TCP_PACKET_MAX, TCP_PACKET_MAX = '{0}'", NetworkInterface.TCP_PACKET_MAX));
                    }
                }
                else
                {
                    Dbg.WARNING_MSG(string.Format("PacketReceiver::_asyncReceive(): receive 0 bytes, disconnect from '{0}'!", socket.RemoteEndPoint));
                    _networkInterface._ConnectState.error = "Disconnect by server";
                    System.Threading.Thread.Sleep(5);
                    Event.fireIn("_closeNetwork", new object[] { _networkInterface });
                    return;
                }
            }
        }

        private void _onRecv(IAsyncResult ar)
        {
            /*AsyncResult result = (AsyncResult)ar;
            AsyncReceiveMethod caller = (AsyncReceiveMethod)result.AsyncDelegate;
            caller.EndInvoke(ar);*/
        }
    }
}
