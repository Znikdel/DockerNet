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

import dockernet.Base.RrClassifier;
import dockernet.Base.RrScheduler;
import inet.queueing.queue.PacketQueue;
import org.omnetpp.queueing.Fork;
import org.omnetpp.queueing.Merge;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Source;


module OsBase
{
    @display("bgb=527,508");
    int numApps = default(1);
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

        input fromAppCpu[];
        input fromAppMemRead[];
        input fromAppMemWrite[];
        input fromAppStorageRead[];
        input fromAppStorageWrite[];

        output toAppCpu[];
        output toAppMem[];
        output toAppStorage[];

    submodules:
        cpuJobs: Source {
            @display("p=109.568,66.56");
            interArrivalTime = 0.0001s;   //produces jobs equals 1Million of intructions
        }
        memJobsRead: Source {
            @display("p=109.568,154.624");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        memJobsWrite: Source {
            @display("p=284.672,66.56");
            interArrivalTime = 0.0001s; //produces jobs equals 1MB data
        }
        storageJobsRead: Source {
            @display("p=104,238");
            interArrivalTime = 0.0001s;  //produces jobs equals 1MB data
        }
        storageJobsWrite: Source {
            @display("p=103.424,322.56");
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

        rrNetScheduler: RrScheduler {
            @display("p=97.28,400.384");
        }
        rrNetDispatcher: RrClassifier {
            @display("p=399.36,417.792");
        }
        rrCpuScheduler: RrScheduler {
            @display("p=225.28,386.048");
        }
        rrMemReadScheduler: RrScheduler {
            @display("p=234.496,288.768");
        }
        rrMemWriteScheduler: RrScheduler {
            @display("p=244.736,218.112");
        }
        rrStorageReadScheduler: RrScheduler {
            @display("p=274.432,154.624");
        }
        rrStorageWriteScheduler: RrScheduler {
            @display("p=194.56,96.256");
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
        //   socketInFromHypervisor++ --> socketOuttoApp++;


        for i=0..numApps-1 {
            //  socketInfromApp++ --> merge.in++;
            socketInfromApp++ --> rrNetScheduler.in++;
            rrNetDispatcher.out++ --> socketOuttoApp++;

        }
        rrNetScheduler.out --> socketOutToHypervisor++;
        socketInFromHypervisor++ --> rrNetDispatcher.in;

        socketInFromHypervisorDocker --> socketOutToDocker;
        socketInFromDocker --> socketOutToHypervisorDocker;
}
