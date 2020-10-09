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

package dockernet.Hardware.Cpu;

import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.Clone;
import org.omnetpp.queueing.Fork;
import org.omnetpp.queueing.Join;


module CpuModule
{
    parameters:
        int cpuNumbers = default(2);
        //    int vmNo=default(2);
        @display("i=device/cpu, bgb=477,393");
    gates:
        input fromOS[];		// Input gates from Operating System
        output toOS[];		// Output gates to Operating System
    submodules:
        cpuCore[cpuNumbers]: CpuCore {
            @display("p=236,154");
        }
        join: Join {
            @display("p=306,69");
        }
        scheduler: Fork {
            @display("p=106,176");
        }
    connections allowunconnected:

        // Connections between all CPU cores and outside
        for i=0..cpuNumbers-1 {
            cpuCore[i].in <-- scheduler.out++;
            cpuCore[i].out --> join.in++;  

        }

         join.out --> toOS++;
         fromOS++ --> scheduler.in;
}
