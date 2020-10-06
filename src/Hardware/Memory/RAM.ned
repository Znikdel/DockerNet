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

package dockernet.Hardware.Memory;

import org.omnetpp.queueing.Queue;
import org.omnetpp.queueing.Sink;


//
// TODO auto-generated module
//Search hasn'r been simulated yet
//just simple read and write simulated
//
module RAM
{
    parameters:
        string type = default("DDR4");
        double size_GB = default(4);
        double dataTransferRate = default(17);  //  GB/s
    //   int numDRAMChips;										// Number of DRAM chips in the same module
     //   int numModules;											// Number of connected slots in the node
     //   @display("i=device/memory");
	   // int vmNo=default(2);
    gates:
        input inRead[];
        input inWrite[];
        output outRead[];

    submodules:
        readQueue: Queue {
            @display("p=111,106");
            serviceTime = 0.0001s; // each queue item eauals 1 MB data transfer.  
        }

        writeQueue: Queue {
            @display("p=210,106");
            serviceTime = 0.0001s; // each queue item eauals 1 MB data transfer.  
        }
        writeJobs: Sink {
            @display("p=305,106");
        }
    connections:
//  for i=0..vmNo-1 {
        inRead++ --> readQueue.in++;
       
        inWrite++ --> writeQueue.in++;
      
//  }
   readQueue.out --> outRead++;
     writeQueue.out --> writeJobs.in++;
}
