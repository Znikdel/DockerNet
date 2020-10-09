//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package dockernet.PhysicalHosts.Node;

import dockernet.Hardware.Cpu.CpuModule;
import dockernet.Hardware.Memory.RAM;
import dockernet.Hardware.Storage.MainStorage;
import dockernet.OperatingSystem.OsBase;
import dockernet.Virtualization.Hypervisor.HypervisorBase;
import inet.node.base.ApplicationLayerNodeBase;
import inet.node.base.TransportLayerNodeBase;
import inet.node.inet.StandardHost;
import inet.transportlayer.tcp.Tcp;
import inet.applications.contract.IApp;
import inet.common.MessageDispatcher;

module NodeBase extends TransportLayerNodeBase
{
    @display("i=abstract/server, bgb=1075,696");
    int numApps = default(0);
    @figure[applicationLayer](type=rectangle; pos=250,6; size=1000,130; lineColor=#808080; cornerRadius=5; fillColor=#ffff00; fillOpacity=0.1);
    @figure[applicationLayer.title](type=text; pos=1245,11; anchor=ne; text="application layer");
    int VMno=default(2);
    numEthInterfaces=1;
    submodules:
        hypervisor: HypervisorBase {
            @display("p=401,28");
        }
        cpuModule: CpuModule {
            @display("p=270,28");
        }
        ram: RAM {
            @display("p=564,28");
        }
        mainStorage: MainStorage {
            @display("p=401,105");
        }

        at: MessageDispatcher {
            parameters:
                @display("p=750,146;b=1000,5,,,,1");
        }


    connections:
        //   for i=0..VMno-1 {
        hypervisor.toCpu --> cpuModule.fromOS++;
        hypervisor.toMemoryRead --> ram.inRead++;
        hypervisor.toMemoryWrite --> ram.inWrite++;
        hypervisor.toStorageRead --> mainStorage.inRead++;
        hypervisor.toStorageWrite --> mainStorage.inWrite++;
        cpuModule.toOS++ --> hypervisor.fromCpu;
        ram.outRead++ --> hypervisor.fromMemory;
        mainStorage.outRead++ --> hypervisor.fromStorage;
   //     }



        at.out++ --> udp.appIn if hasUdp;
        at.in++ <-- udp.appOut if hasUdp;

        at.out++ --> tcp.appIn if hasTcp;
        at.in++ <-- tcp.appOut if hasTcp;

        at.out++ --> sctp.appIn if hasSctp;
        at.in++ <-- sctp.appOut if hasSctp;

        at.out++ --> tn.in++;
        at.in++ <-- tn.out++;
		for i=0..VMno-1{
       		hypervisor.socketOutApp++ --> at.in++;
        	at.out++ --> hypervisor.socketInApp++;
		
        	hypervisor.socketOutDocker++ --> at.in++;
        	at.out++ --> hypervisor.socketInDocker++;
		}
}
