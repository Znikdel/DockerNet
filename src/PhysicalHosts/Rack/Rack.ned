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

package dockernet.PhysicalHosts.Rack;

import dockernet.PhysicalHosts.Blade.Blade;


module Rack
{
    parameters:
        @display("i=old/ipc");
        int numBlades=default(2);		// Number of blades.
        int nodesPerBlade=default(2);	// Number of nodes per blade

    gates:
        inout ethg[numBlades];

    submodules:
            blade[numBlades]: Blade {
            parameters:
                numNodes = nodesPerBlade;
            	@display("p=165,176");
        }
    connections:

        // Connections between Nodes and Switch
        for i=0..numBlades-1 {
            blade[i].ethg <--> ethg++;
        }
}
