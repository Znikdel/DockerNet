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

import org.omnetpp.queueing.Queue;


//
// TODO auto-generated module
//
module CpuCore
{
    parameters:
        volatile double speed=default(2000); //in MIPS (Million Instructions per Second)
    gates:
        input in;
        output out;
    submodules:
        queue: Queue {
            @display("p=116,123");
            serviceTime = 0.0005s; // each queue item eauals 1 Million instructions.  
           
        }
    connections:
        in --> queue.in++;
        queue.out --> out;
}
