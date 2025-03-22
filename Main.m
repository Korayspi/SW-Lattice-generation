%% SW-Lattice structure generator
% Here, SW-lattice is generated using few different parameters. 
% Nx, Ny and Nz are the number of cells in x, y and z direction, respectively.
% UcL is the length of one side of unit cell.
% fr2an and rad2fr are geometric parameters, determining the length ratio
% between frame-anchor and radial-frame regions.

%% Creating the required structural variables
Nx=3; Ny=3; Nz=2; UcL=10; fr2an=0.75; rad2fr=0.75;
[n,m,Con,Nod,anch_ele,frame_ele,rad_ele] = makestr_SW(Nx,Ny,Nz,UcL,fr2an,rad2fr);

%% Plotting the result
PlotGrnd(Nod, Con)