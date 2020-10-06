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

package dockernet.Virtualization.Containers.ContainersManager;

import dockernet.Base.RrClassifier;
import dockernet.Base.RrScheduler;
import dockernet.Virtualization.Containers.RunningContainers.Docker;
import inet.queueing.classifier.ContentBasedClassifier;
import inet.queueing.classifier.WrrClassifier;
import inet.queueing.scheduler.ContentBasedScheduler;
import inet.queueing.scheduler.WrrScheduler;
import org.omnetpp.queueing.Fork;
import org.omnetpp.queueing.Merge;


module DockerEngine
{
    int dockerNumber = default(0);
    gates:
        input socketIn;
        output socketOut;

    submodules:
        docker[dockerNumber]: Docker {
            @display("p=270,63");
        }

        rrScheduler: RrScheduler {
            @display("p=357,122");
        }
        rrClassifier: RrClassifier {
            @display("p=147,112");
        }
    connections:

        
        rrScheduler.out --> socketOut;
        socketIn --> rrClassifier.in;
        for i=0..dockerNumber-1{
        	rrClassifier.out++ --> docker[i].socketIn;
        	docker[i].socketOut --> rrScheduler.in++;
        }
}
