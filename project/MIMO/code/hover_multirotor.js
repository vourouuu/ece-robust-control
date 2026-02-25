// T = 60.14 sec with PD controller

// Constants
var L = 0.1, m = 1, Ixx = 1/0.12/100, g = 9.81;
// Inputs
var f = 0, tau = 0, fL = 0, fR = 0;
// Gains
var Kpy = 0.006, Kdy = 0.03, Kpz = 0.4, Kdz = 1.5, Kpphi = 0.805, Kdphi = 0.02;
// Variables
var y_ddot = 0, z_ddot = 0, phi_ddot = 0, phi_ref = 0, dphi_ref = 0;


function controlFunction(vehicle){
    y_ddot = Kpy * (0 - vehicle.x) + Kdy * (0 - vehicle.dx); // horizontal axis
    z_ddot = Kpz * (0 - vehicle.y) + Kdz * (0 - vehicle.dy); // vertical axis
  
    phi_ref = -1/g * y_ddot;
    dphi_ref = 0;
    phi_ddot = Kpphi * (phi_ref + vehicle.theta) + Kdphi * (dphi_ref + vehicle.dtheta);
    
    f = m * g + m * z_ddot;
    tau = Ixx * phi_ddot;  
    fL = f/2 - tau/(2 * L);
    fR = tau/L + fL;
  
    return {thrustLeft: fL, thrustRight: fR}
};


