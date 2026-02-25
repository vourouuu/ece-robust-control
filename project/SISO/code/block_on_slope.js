// T = 2.6 sec with PID controller
var u0 = 0, u1 = 0, u2 = 0, u3 = 0, u4 = 0, u5 = 0, u6 = 0, u7 = 0;
var e0 = 0, e1 = 0, e2 = 0, e3 = 0, e4 = 0, e5 = 0, e6 = 0, e7 = 0;

function controlFunction(block) {
  e6 = e5;
  e5 = e4;
  e4 = e3;
  e3 = e2;
  e2 = e1;
  e1 = e0;
  e0 = block.x / 2;

  u7 = u6;
  u6 = u5;  
  u5 = u4;
  u4 = u3;
  u3 = u2;
  u2 = u1;
  u1 = u0;
  
  u0 = 1.8168 * u1 - 0.8168 * u2 - 7.500 * e0 + 14.6890 * e1 - 7.1925 * e2;
  
  monitor('u', u0);
  monitor('x', block.x);
 
  return -5 + u0 * 10; 
}
