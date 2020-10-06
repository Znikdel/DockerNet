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

import dockernet.OperatingSystem.OsBase;
import dockernet.Virtualization.Containers.ContainersManager.DockerEngine;
import inet.applications.contract.IApp;

module VM
{
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

        input socketInApp[];
        output socketOutApp[];

		input socketInDocker[];
        output socketOutDocker[];
		
    submodules:
        os: OsBase {
            @display("p=97,97");
        }
        app[numApps]: <> like IApp {
            parameters:
                @display("p=300,49,row,150");
        }
        dockerEngine: DockerEngine {
            @display("p=300,127");
        }
    connections:

        for i=0..numApps-1 {
            app[i].socketOut --> os.socketInfromApp++;
            os.socketOuttoApp++ --> app[i].socketIn;
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
