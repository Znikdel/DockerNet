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

package dockernet.Applications;

import inet.applications.contract.IApp;
import dockernet.Base.RrClassifier;
import dockernet.Base.RrScheduler;
import inet.queueing.queue.PacketQueue;
import org.omnetpp.queueing.Fork;
import org.omnetpp.queueing.Merge;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Source;

module TcpINETApp
{
    @display("bgb=746,405");

    gates:
        output toCpu;
        output toMemoryRead;
        output toMemoryWrite;
        output toStorageRead;
        output toStorageWrite;

        input fromCpu;
        input fromMemory;
        input fromStorage;

        output socketOutToHypervisor;
        input socketInFromHypervisor;

    submodules:
        tcpINETapp: <> like IApp {
            parameters:
                @display("p=259,118,row,150");
        }
        cpuJobs: Source {
            @display("p=142,45");
            interArrivalTime = 0.0001s;   //produces jobs equals 1Million of intructions
        }
        memJobsRead: Source {
            @display("p=544,69");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        memJobsWrite: Source {
            @display("p=431,69");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        storageJobsRead: Source {
            @display("p=568,349");
            interArrivalTime = 0.0001s;  //produces jobs equals 1MB data
        }
        storageJobsWrite: Source {
            @display("p=441,349");
            interArrivalTime = 0.0001s;  //produces jobs equals 1MB data
        }
        cpu: Sink {
            @display("p=132,137");
        }
        mem: Sink {
            @display("p=132,202");
        }
        storage: Sink {
            @display("p=132,268");
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

        tcpINETapp.socketOut --> socketOutToHypervisor;
        socketInFromHypervisor --> tcpINETapp.socketIn;
}
