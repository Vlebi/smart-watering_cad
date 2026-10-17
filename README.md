DripLogic Node Watering System
I designed this project for my week 1 pcb. The main focus here is a total physical separation between the fluid lines and the control electronics. If a seal breaks, water simply drips away instead of flooding the circuit board.

How the Hardware Works
The microcontroller and power circuitry live in a dedicated enclosure sealed by a flat top lid. Instead of relying on rubber O-rings that degrade under UV light, I added crush ribs along the inner lip geometry. The lid snaps on with a tight friction fit that keeps rain and moisture out.

For the water source, I modeled the side caddy threads directly around common 1.5-liter drink bottles (like local Xixo and Hell iced tea bottles) using a 28.5 mm root diameter. Inverted bottles naturally glug and stop draining due to internal vacuum, so I added a secondary 4.3 mm hole right beside the main drain outlet. You can push a standard 4 mm aquarium air tube up to the top of the bottle through this hole to break the vacuum.

The whole assembly slides onto a wall bracket equipped with a bottom stop ledge. You can screw the bracket to a garden post with M4 countersunk flatheads and slide the entire node off whenever you need to swap batteries or flash new code. For flow control, I created mounting cradles for standard WSV-12V 1/2-inch solenoid valves along with integrated manifold blocks, plus a full set of 10 mm internal bore threaded pipe fittings to route drip lines around garden beds.

A layer height of 0.2 mm or 0.28 mm gives you a clean result while keeping thread geometry sharp. Set your slicer to at least 4 perimeter walls so water doesn't weep through the layer lines under bottle pressure. For infill, 20% to 30% gyroid or cubic is plenty strong. When placed flat on the build plate, almost every component prints cleanly without needing print supports.

<img width="2337" height="1251" alt="wdawhnajfh" src="https://github.com/user-attachments/assets/25689a51-92b1-439c-a7cd-39862fc009f7" />

