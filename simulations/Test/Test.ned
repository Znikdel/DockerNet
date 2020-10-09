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

package dockernet.simulations.Test;

import dockernet.Hardware.Cpu.CpuModule;
import dockernet.Hardware.Memory.RAM;
import dockernet.Hardware.Storage.MainStorage;
import dockernet.OperatingSystem.OsBase;
import dockernet.PhysicalHosts.Node.NodeBase;
import dockernet.PhysicalHosts.Rack.Rack;
import dockernet.Virtualization.Hypervisor.HypervisorBase;
import inet.networklayer.configurator.ipv4.Ipv4FlatNetworkConfigurator;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth100M;
import inet.node.inet.Router;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;
import inet.visualizer.linklayer.DataLinkCanvasVisualizer;


//
// TODO Auto-generated network
//
network Test
{
    @display("bgb=534,306");
    int numBlades = default(2);
    submodules:
   //     client: NodeBase {
   //         @display("p=152,43");
   //     }
 //      server: NodeBase {
 //           @display("p=376,43");
 //       }
 //       router: Router {
//           @display("p=256,43");
//        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=295,236");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=217,236");
        }
        rack: Rack {
            @display("p=152,132");
        }
        rack1: Rack {
            @display("p=376,132");
        }
        router1: Router {
            @display("p=256,133");
        }
    connections:
  //      server.ethg++ <--> Eth100M <--> router.ethg++;
  //      client.ethg++ <--> Eth100M <--> router.ethg++;
        for i=0..numBlades-1 {
            router1.ethg++ <--> rack1.ethg++;
            router1.ethg++ <--> rack.ethg++;
        }

}
