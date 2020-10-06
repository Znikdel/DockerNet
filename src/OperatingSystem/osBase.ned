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

package dockernet.OperatingSystem;

import inet.queueing.queue.PacketQueue;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Source;


module OsBase
{
    @display("bgb=527,508");
    gates:
        output toCpu;
        output toMemoryRead;
        output toMemoryWrite;
        output toStorageRead;
        output toStorageWrite;

        input fromCpu;
        input fromMemory;
        input fromStorage;

        input socketInfromApp[];
        output socketOuttoApp[];

        output socketOutToHypervisor[];
        input socketInFromHypervisor[];
        
        output socketOutToDocker;
        input socketInFromDocker;
        
        input socketInFromHypervisorDocker;
		output socketOutToHypervisorDocker;
    submodules:
        cpuJobs: Source {
            @display("p=127,43");
            interArrivalTime = 0.0001s;   //produces jobs equals 1Million of intructions
        }
        memJobsRead: Source {
            @display("p=127,141");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        memJobsWrite: Source {
            @display("p=244.736,140.288");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        storageJobsRead: Source {
            @display("p=104,238");
            interArrivalTime = 0.0001s;  //produces jobs equals 1MB data
        }
        storageJobsWrite: Source {
            @display("p=110,328");
            interArrivalTime = 0.0001s;  //produces jobs equals 1MB data
        }
        cpu: Sink {
            @display("p=371,124");
        }
        mem: Sink {
            @display("p=371,203");
        }
        storage: Sink {
            @display("p=371,289");
        }
        
    connections:
        cpuJobs.out --> toCpu;

        memJobsWrite.out --> toMemoryWrite;
        memJobsRead.out --> toMemoryRead;
        storageJobsWrite.out --> toStorageWrite;
        storageJobsRead.out --> toStorageRead;
        fromCpu --> cpu.in++;
        fromMemory --> mem.in++;
        fromStorage --> storage.in++;
        socketInFromHypervisor++ --> socketOuttoApp++;
        socketInfromApp++ --> socketOutToHypervisor++;
        socketInFromHypervisorDocker --> socketOutToDocker;
        socketInFromDocker--> socketOutToHypervisorDocker;
        
}
