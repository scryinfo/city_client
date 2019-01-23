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
    /// 网络模块
    /// 处理连接、收发数据
    /// </summary>
    ///    
    public class NetworkInterface
	{
        public int testId = 1;
        public delegate void AsyncConnectMethod(ConnectState state);
        public const int TCP_PACKET_MAX = 1024*1024*2;
        public delegate void ConnectCallback(string ip, int port, bool success, object userData);

		protected Socket _socket = null;
		PacketReceiver _packetReceiver = null;
		PacketSender _packetSender = null;

		public bool connected = false;

        //系统事件, 10000 服务器断开连接 
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
			if(valid())
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
           if(_socket != null)
			{
				_socket.Close(0);
				_socket = null;
				Event.fireAll("onDisconnect", new object[]{});
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
            _packetReceiver = new PacketReceiver(this);
            _packetReceiver.startRecv();
            connected = true;
            state.error = "Success";
            CityLuaUtil.CallMethod("Event", "Brocast", new object[] { "m_onConnectionState", state });

			if (state.connectCB != null)
				state.connectCB(state.connectIP, state.connectPort, true, state.userData);
		}

		private static void connectCB(IAsyncResult ar)
		{
			ConnectState state = null;
			
			try 
			{
				// Retrieve the socket from the state object.
				state = (ConnectState) ar.AsyncState;

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
		/// 在非主线程执行：连接服务器
		/// </summary>
		private void _asyncConnect(ConnectState state)
		{
			Dbg.DEBUG_MSG(string.Format("NetWorkInterface::_asyncConnect(), will connect to '{0}:{1}' ...", state.connectIP, state.connectPort));
			try
			{
                //state.socket.Connect(state.connectIP, state.connectPort);
                IAsyncResult connResult = state.socket.BeginConnect(state.connectIP, state.connectPort, null, null);
		        connResult.AsyncWaitHandle.WaitOne(4000, true);  //等待2秒
		        if (!connResult.IsCompleted)
		        {
                    state.error = "Failed";
                    Dbg.ERROR_MSG(string.Format("NetWorkInterface::_asyncConnect(), connect to '{0}:{1}' failed!'", state.connectIP, state.connectPort));
                    CityLuaUtil.CallMethod("Event", "Brocast", new object[] { "m_onConnectionState", state });
                    close();
			        //处理连接不成功的动作
		        }
		        else
		        {
                    //处理连接成功的动作
                    _asyncConnectCB1(state);
		        }
            }
            catch (Exception e)
			{
				Dbg.ERROR_MSG(string.Format("NetWorkInterface::_asyncConnect(), connect to '{0}:{1}' fault! error = '{2}'", state.connectIP, state.connectPort, e));
				state.error = e.ToString();
			}
		}

		/// <summary>
		/// 在非主线程执行：连接服务器结果回调
		/// </summary>
		private void _asyncConnectCB1(ConnectState state)
		{
            Event.fireIn("_onConnectionState", new object[] { state });            
        }

        private void _asyncConnectCB(IAsyncResult ar)
		{
            ConnectState state = (ConnectState)ar.AsyncState;
            state.error = "";
            Event.fireIn("_onConnectionState", new object[] { state });            
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

			ConnectState state = new ConnectState();
			state.connectIP = ip;
			state.connectPort = port;
			state.connectCB = callback;
			state.userData = userData;
			state.socket = _socket;
			state.networkInterface = this;

			Dbg.DEBUG_MSG("connect to " + ip + ":" + port + " ...");
			connected = false;
			
			// 先注册一个事件回调，该事件在当前线程触发
			Event.registerIn("_onConnectionState", this, "_onConnectionState");

            /*var v = new AsyncConnectMethod(this._asyncConnect);
			v.BeginInvoke(state, new AsyncCallback(this._asyncConnectCB), state);*/
            _asyncConnect(state);
            //_asyncConnectCB();

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
            if (!valid()) {
                if (SYSEVENT.SYSEVENT_DISCONNECT == _sysEvent) {                    
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
