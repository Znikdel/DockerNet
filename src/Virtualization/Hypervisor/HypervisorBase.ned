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

package dockernet.Virtualization.Hypervisor;

import dockernet.Virtualization.VirtualMachines.VM;
import inet.linklayer.ethernet.EtherQosQueue;
import org.omnetpp.queueing.Clone;
import org.omnetpp.queueing.Fork;
import org.omnetpp.queueing.Merge;
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Source;

module HypervisorBase
{
    parameters:
        @display("bgb=527,508");
        int VMno = default(2);
    gates:
        output toCpu;
        output toMemoryRead;
        output toMemoryWrite;
        output toStorageRead;
        output toStorageWrite;

        input fromCpu;
        input fromMemory;
        input fromStorage;

        input socketInApp[VMno];
        output socketOutApp[VMno];

        input socketInDocker[VMno];
        output socketOutDocker[VMno];

    submodules:
        vm[VMno]: VM {
            @display("p=162,247");
        }

        memReadScheduler: Merge {
            @display("p=327,271");
        }
        memWriteScheduler: Merge {
            @display("p=327,345");
        }
        storageReadScheduler: Merge {
            @display("p=327,110");
        }
        storageWriteScheduler: Merge {
            @display("p=327,188");
        }
        cpuScheduler: Merge {
            @display("p=327,419");
        }
        cpuResponseScheduler: Fork {
            @display("p=162,419");
        }
        memResponseScheduler: Fork {
            @display("p=84,165");
        }
        storageResponseScheduler: Fork {
            @display("p=162,81");
        }
    connections:
        for i=0..VMno-1 {
            vm[i].toCpu --> cpuScheduler.in++;
            vm[i].toMemoryWrite --> memWriteScheduler.in++;
            vm[i].toMemoryRead --> memReadScheduler.in++;
            vm[i].toStorageWrite --> storageWriteScheduler.in++;
            vm[i].toStorageRead --> storageReadScheduler.in++;
            cpuResponseScheduler.out++ --> vm[i].fromCpu;
            storageResponseScheduler.out++ --> vm[i].fromStorage;
            memResponseScheduler.out++ --> vm[i].fromMemory;
            socketInApp[i] --> vm[i].socketInApp++;
            vm[i].socketOutApp++ --> socketOutApp[i];
            socketInDocker[i] --> vm[i].socketInDocker++;
            vm[i].socketOutDocker++ --> socketOutDocker[i];
        }
        storageReadScheduler.out --> toStorageRead;
        storageWriteScheduler.out --> toStorageWrite;
        memReadScheduler.out --> toMemoryRead;
        memWriteScheduler.out --> toMemoryWrite;
        cpuScheduler.out --> toCpu;
        fromCpu --> cpuResponseScheduler.in;
        fromMemory --> memResponseScheduler.in;
        fromStorage --> storageResponseScheduler.in;

}
