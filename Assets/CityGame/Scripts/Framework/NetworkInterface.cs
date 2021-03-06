﻿namespace City
{
    using UnityEngine;
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

    /// <summary>
    /// Network module
    /// Handle connections, send and receive data
    /// </summary>
    ///    
    public class NetworkInterface
    {
        public int testId = 1;
        public delegate void AsyncConnectMethod(ConnectState state);
        public delegate void AsyncConnectTimeOutMethod(DateTime start);
        public const int TCP_PACKET_MAX = 1024 * 1024 * 1;
        public delegate void ConnectCallback(string ip, int port, bool success, object userData);
        public delegate void ConnectTimeOutCallback(DateTime start, int test);
        public AsyncConnectMethod _connectDelegate = null;
        public ConnectState _ConnectState = null;
        protected Socket _socket = null;
        PacketReceiver _packetReceiver = null;
        PacketSender _packetSender = null;

        public bool connected = false;
        private DateTime _connectionStart;
        private IAsyncResult _result;
#if UNITY_EDITOR
        private float _connectionTimeOut = 2000;
#else
        private float _connectionTimeOut = 8000;            
#endif

        //System event, 10000 server disconnected
        public SYSEVENT _sysEvent = 0;

        public class ConnectState
        {
            // for connect
            public string connectIP = "";
            public int connectPort = 0;
            public ConnectCallback connectCB = null;
            public object userData = null;
            public Socket socket = null;
            public NetworkInterface networkInterface = null;
            public string error = "";
        }

        public NetworkInterface()
        {
            reset();
        }

        ~NetworkInterface()
        {
            Dbg.DEBUG_MSG("NetworkInterface::~NetworkInterface(), destructed!!!");
            reset();
        }

        public virtual Socket sock()
        {
            return _socket;
        }

        public void reset()
        {
            if (valid())
            {
                Dbg.DEBUG_MSG(string.Format("NetworkInterface::reset(), close socket from '{0}'", _socket.RemoteEndPoint.ToString()));
                _socket.Close(0);
            }
            _socket = null;
            _packetReceiver = null;
            _packetSender = null;
            connected = false;
        }


        public void close()
        {
            if (_socket != null)
            {
                _socket.Close(0);
                _socket = null;
                Event.fireAll("onDisconnect", new object[] { });
            }

            _socket = null;
            connected = false;
        }

        public virtual PacketReceiver packetReceiver()
        {
            return _packetReceiver;
        }

        public virtual bool valid()
        {
            return ((_socket != null) && (_socket.Connected == true));
        }

        public void _onConnectionState(ConnectState state)
        {
            City.Event.deregisterIn(this);

            bool success = (state.error == "Connect server succeed" && valid());
            if (success)
            {
                Dbg.DEBUG_MSG(string.Format("NetworkInterface::_onConnectionState(), connect to {0} is success!", state.socket.RemoteEndPoint.ToString()));
                _packetReceiver = new PacketReceiver(this);
                _packetReceiver.startRecv();
                connected = true;
            }
            else
            {
                reset();
                Dbg.DEBUG_MSG(string.Format("NetworkInterface::_onConnectionState(), connect error! ip: {0}:{1}, err: {2}", state.connectIP, state.connectPort, state.error));
            }

            //CityLuaUtil.CallMethod("Event", "Brocast", new object[] { "m_onConnectionState", state });

            if (state.connectCB != null)
                state.connectCB(state.connectIP, state.connectPort, success, state);
        }

        private static void connectCB(IAsyncResult ar)
        {
            ConnectState state = null;

            try
            {
                // Retrieve the socket from the state object.
                state = (ConnectState)ar.AsyncState;

                // Complete the connection.
                state.socket.EndConnect(ar);

                Event.fireIn("_onConnectionState", new object[] { state });
            }
            catch (Exception e)
            {
                state.error = e.ToString();
                Event.fireIn("_onConnectionState", new object[] { state });
            }
        }

        /// <summary>
        /// Execute in non-main thread: connect to the server
        /// </summary>
        private void _asyncConnect(ConnectState state)
        {
            Dbg.DEBUG_MSG(string.Format("NetWorkInterface::_asyncConnect(), will connect to '{0}:{1}' ...", state.connectIP, state.connectPort));
            try
            {
                state.socket.Connect(state.connectIP, state.connectPort);
            }
            catch (Exception e)
            {
                //Dbg.DEBUG_MSG(string.Format("NetWorkInterface::_asyncConnect(), connect to '{0}:{1}' fault! error = '{2}'", state.connectIP, state.connectPort, e));
                state.error = e.ToString();
            }
        }

        /// <summary>
        /// Execution on non-main thread: connection server result callback
        /// </summary>
        private void _asyncConnectCB(IAsyncResult ar)
        {
            ConnectState state = (ConnectState)ar.AsyncState;
            AsyncResult result = (AsyncResult)ar;
            AsyncConnectMethod caller = (AsyncConnectMethod)result.AsyncDelegate;

            //Dbg.DEBUG_MSG(string.Format("NetWorkInterface::_asyncConnectCB(), connect to '{0}:{1}' finish. error = '{2}'", state.connectIP, state.connectPort, state.error));
            if (state.error == "") {
                _ConnectState.error = "Connect server succeed";
            }
            
            // Call EndInvoke to retrieve the results.
            caller.EndInvoke(ar);
            Event.fireIn("_onConnectionState", new object[] { state });
            
        }

        void OnCheckConnectionTimeOut(DateTime start)
        {
            TimeSpan checkinterval = TimeSpan.FromMilliseconds(100);
            while ((System.DateTime.Now - start).TotalMilliseconds < _connectionTimeOut)
            {
                System.Threading.Thread.Sleep(checkinterval);
            }
            if (_ConnectState.error != "Connect server succeed")
            {
                //Timeout handling
                close();
                _ConnectState.error = "Connection TimeOut";
                Event.fireIn("_onConnectionState", new object[] { _ConnectState });

                AsyncResult result = (AsyncResult)_result;
                if(!result.EndInvokeCalled)
                    _connectDelegate.EndInvoke(_result);
                //Dbg.DEBUG_MSG(string.Format("NetWorkInterface::_asyncConnect(), connect to '{0}:{1}' fault! error = 'TimeOut'", _ConnectState.connectIP, _ConnectState.connectPort));
            }
        }


        public void connectTo(string ip, int port, ConnectCallback callback, object userData)
        {
            if (valid())
                throw new InvalidOperationException("Have already connected!");

            if (!(new Regex(@"((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))")).IsMatch(ip))
            {
                IPHostEntry ipHost = Dns.GetHostEntry(ip);
                ip = ipHost.AddressList[0].ToString();
            }

            // Security.PrefetchSocketPolicy(ip, 843);
            IPAddress[] hostAddresses = Dns.GetHostAddresses(ip);
            IPAddress[] outIPs = hostAddresses;
            AddressFamily addressFamily = AddressFamily.InterNetwork;
            if (Socket.OSSupportsIPv6 && this.IsHaveIpV6Address(hostAddresses, ref outIPs))
            {
                addressFamily = AddressFamily.InterNetworkV6;
            }
            _socket = new Socket(addressFamily, SocketType.Stream, ProtocolType.Tcp);
            _socket.SetSocketOption(System.Net.Sockets.SocketOptionLevel.Socket, SocketOptionName.ReceiveBuffer, NetworkInterface.TCP_PACKET_MAX * 2);
            _socket.SetSocketOption(System.Net.Sockets.SocketOptionLevel.Socket, SocketOptionName.SendBuffer, NetworkInterface.TCP_PACKET_MAX * 2);
            //_socket.SetSocketOption(System.Net.Sockets, SocketOptionName.SendTimeout, 6000)

            _socket.NoDelay = true;
            //_socket.Blocking = false;

            _ConnectState = new ConnectState();
            _ConnectState.connectIP = ip;
            _ConnectState.connectPort = port;
            _ConnectState.connectCB = callback;
            _ConnectState.userData = userData;
            _ConnectState.socket = _socket;
            _ConnectState.networkInterface = this;

            Dbg.DEBUG_MSG("connect to " + ip + ":" + port + " ...");
            connected = false;

            // First register an event callback, the event is triggered in the current thread
            Event.registerIn("_onConnectionState", this, "_onConnectionState");

            _connectDelegate = new AsyncConnectMethod(this._asyncConnect);
            _result = _connectDelegate.BeginInvoke(_ConnectState, new AsyncCallback(this._asyncConnectCB), _ConnectState);
            _connectionStart = System.DateTime.Now;

            var v = new AsyncConnectTimeOutMethod(this.OnCheckConnectionTimeOut);
            v.BeginInvoke(_connectionStart, null, null);
        }

        private bool IsHaveIpV6Address(IPAddress[] IPs, ref IPAddress[] outIPs)
        {
            int length = 0;
            for (int index = 0; index < IPs.Length; ++index)
            {
                if (AddressFamily.InterNetworkV6.Equals((object)IPs[index].AddressFamily))
                    ++length;
            }
            if (length <= 0)
                return false;
            outIPs = new IPAddress[length];
            int num = 0;
            for (int index = 0; index < IPs.Length; ++index)
            {
                if (AddressFamily.InterNetworkV6.Equals((object)IPs[index].AddressFamily))
                    outIPs[num++] = IPs[index];
            }
            return true;
        }


        public bool send(MemoryStream stream)
        {
            if (!valid())
            {
                throw new ArgumentException("invalid socket!");
            }

            if (_packetSender == null)
                _packetSender = new PacketSender(this);

            return _packetSender.send(stream);
        }

        public void process()
        {
            if (!valid())
            {
                if (SYSEVENT.SYSEVENT_DISCONNECT == _sysEvent)
                {
                    CityLuaUtil.CallMethod("CityEngineLua.MessageReader", "onConnectError", (int)_sysEvent);
                    _sysEvent = SYSEVENT.SYSEVENT_DEFAULT;
                }
                return;
            }

            if (_packetReceiver != null)
                _packetReceiver.process();
        }
    }
}
