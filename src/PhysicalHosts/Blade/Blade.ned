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

package dockernet.PhysicalHosts.Blade;
import dockernet.PhysicalHosts.Node.NodeBase;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.Router;
import ned.DatarateChannel;

channel ethernet_bladeChannel extends DatarateChannel
{
    parameters:
        //        delay = default(normal(0.00015, 0.00005)) @unit(s);		// Normal (150us, 50us)
        delay = default(75.0us);
        datarate = default(1000Mbps);					// 1Gbps

       // string nodeType;
}


module Blade

{
    parameters:
        int numNodes = default(2);	// Number of nodes.
        @display("i=old/drive2;bgb=262,211");

    gates:
        inout ethg;		// Gates

    submodules:

        // Switch
        switch: EtherSwitch {
           parameters:
               @display("i=abstract/switch,p,220,150;p=165,99");
        }

        node[numNodes]: NodeBase {
            @display("p=61,99");
        }
   //     router: Router {
   //         @display("p=156,155");
   //     }
    connections allowunconnected:

        // Connections between Nodes and Switch
        for i=0..numNodes-1 {
            node[i].ethg++ <--> ethernet_bladeChannel <--> switch.ethg++;
          //  node[i].ethg++ <-->  switch.ethg++;
        }

        // Connection between switch and outside
        switch.ethg++ <--> ethernet_bladeChannel <--> ethg;
       // switch.ethg++ <--> ethg;
}

