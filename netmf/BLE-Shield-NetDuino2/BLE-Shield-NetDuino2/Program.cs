using System;
using System.IO.Ports;
using System.Text;
using System.Threading;
using Microsoft.SPOT;
using SecretLabs.NETMF.Hardware.Netduino;

public class Program
{
    public static void Main()
    {
        Debug.Print("BLE Shield");
        var port = SerialPorts.COM1; // using D0 & D1
        //var port = SerialPorts.COM2; // using D2 & D3
        var bleShield = new SerialPort(port, 19200, Parity.None, 8, StopBits.None);
        bleShield.DataReceived += (sender, args) =>
        {
            var receiveBuffer = new byte[16];
            int bytesReceived = bleShield.Read(receiveBuffer, 0, receiveBuffer.Length);
            if (bytesReceived > 0)
            {
                Debug.Print("Bytes received: " + bytesReceived);
                Debug.Print(new String(Encoding.UTF8.GetChars(receiveBuffer)));
            }
        };
        bleShield.Open();
        while (true)
        {
            var random = new Random();
            var sendBuffer = new byte[4];
            random.NextBytes(sendBuffer);
            bleShield.Write(sendBuffer, 0, sendBuffer.Length);
            Thread.Sleep(1000);
        }
    }
}