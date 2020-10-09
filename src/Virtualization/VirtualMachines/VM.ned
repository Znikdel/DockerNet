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

package dockernet.Virtualization.VirtualMachines;

import dockernet.Applications.TcpINETApp;
import dockernet.OperatingSystem.OsBase;
import dockernet.Virtualization.Containers.ContainersManager.DockerEngine;
import inet.applications.contract.IApp;

module VM
{
    int numApps = default(1);
    int numCpus = default(1);
    gates:
        output toCpu;
        output toMemoryRead;
        output toMemoryWrite;
        output toStorageRead;
        output toStorageWrite;

        input fromCpu;
        input fromMemory;
        input fromStorage;

        input socketInApp[];
        output socketOutApp[];

        input socketInDocker[];
        output socketOutDocker[];

    submodules:
        os: OsBase {
            @display("p=97,97");
        }
      
        dockerEngine: DockerEngine {
            @display("p=300,127");
        }
        app[numApps]: TcpINETApp {
            @display("p=267,39");
        }
    connections:

        for i=0..numApps-1 {
            app[i].socketOutToHypervisor --> os.socketInfromApp++;
            os.socketOuttoApp++ --> app[i].socketInFromHypervisor;
            os.toAppCpu[i] --> app[i].fromCpu;
            os.toAppMem[i] --> app[i].fromMemory;
            os.toAppStorage[i] --> app[i].fromStorage;
            os.fromAppCpu[i] <-- app[i].toCpu;
            os.fromAppMemRead[i] <-- app[i].toMemoryRead;
            os.fromAppMemWrite[i] <-- app[i].toMemoryWrite;
            os.fromAppStorageRead[i] <-- app[i].toStorageRead;
            os.fromAppStorageWrite[i] <-- app[i].toStorageWrite; 
        }

        os.toCpu --> toCpu;
        os.toMemoryRead --> toMemoryRead;
        os.toMemoryWrite --> toMemoryWrite;
        os.toStorageRead --> toStorageRead;
        os.toStorageWrite --> toStorageWrite;
        fromCpu --> os.fromCpu;
        fromMemory --> os.fromMemory;
        fromStorage --> os.fromStorage;
        socketInApp++ --> os.socketInFromHypervisor++;
        os.socketOutToHypervisor++ --> socketOutApp++;
        os.socketOutToDocker --> dockerEngine.socketIn;
        dockerEngine.socketOut --> os.socketInFromDocker;
        socketInDocker++ --> os.socketInFromHypervisorDocker;
        os.socketOutToHypervisorDocker --> socketOutDocker++;
}
