DripLogic Node Watering System
A modular, weather-hardened, 3D-printable automated garden-watering node engineered with a strict wet/dry isolation architecture. This design protects sensitive electronics from fluid leaks, condensation, and outdoor elements.

Architecture and Key Features
Strict wet/dry isolation: The core electronics housing uses a solid, flat top lid with an internal tongue-and-groove lap joint and friction crush ribs, keeping the microcontroller, power supply, and wiring dry.
Optimized PET bottle support: The side-bottle caddy features precision-tuned internal threads with a 28.5 mm root diameter, optimized for standard European and Hungarian 1.5 L beverage bottles, including Xixo and Hell iced-tea bottles.
Vacuum-break snorkel system: A dedicated 4.3 mm breather port is offset from the main water outlet. It accepts a 4 mm silicone or PVC snorkel tube that runs to the top of the inverted bottle, eliminating vapor lock.
Tool-free slide-lock mounting: A rugged dovetail rail and stop-ledge bracket system, anchored with M4 hardware, allows the entire node to slide on and off easily for maintenance or battery replacement.
WSV-12V solenoid integration: Custom cradles and inline valve manifolds are designed specifically for standard 1/2-inch, 12 V DC liquid solenoid valves.
Comprehensive modular plumbing library: A complete ecosystem of hollow threaded fittings with a 10 mm internal water-bore diameter supports custom garden layouts.
Component Ecosystem and Parts List
The OpenSCAD script is fully parametric and includes a built-in part selector, part = "...", for previewing, exporting, or batch-printing individual components.

part value	Description
base	Electronics tray with PCB standoffs, J1/J2 cutouts, and a rear wire slot.
lid	Flat, solid top plate with a lap-joint groove and crush ribs for a sealed fit.
bracket	Wall-mounting plate with a male dovetail rail and M4 countersunk holes.
side_caddy	Isolated wet-zone bottle holder with an offset threaded outlet and snorkel port.
solenoid_holder	Mounting cradle for the WSV-12V 1/2-inch solenoid-valve body.
straight_fitting	Modular straight water-path connector with a 10 mm bore.
curve_fitting	Modular curved or angled water-path connector.
elbow90_fitting	Modular 90-degree elbow water-path connector.
female_fitting	Modular female socket coupling.
female_tube_long	Extended 50 mm double-female connection tube.
solenoid_adapter	Transition adapter from modular male to 1/2-inch female.
solenoid_inline_valve	Integrated flow-control manifold with a top port for a solenoid plunger.
sprinkler_fitting	End-cap nozzle with a radial array of angled spray-distribution holes.
print_plate	Prearranged layout containing all components placed flat on the build plate.
Printing Recommendations
Material: PETG or ASA is strongly recommended for outdoor UV and weather resistance.
Layer height: Use 0.2 mm or 0.28 mm layers for strong, well-defined threads.
Perimeters/walls: Use three or four walls to improve watertightness and pressure integrity.
Infill: Use 20-30% grid or gyroid infill.
Supports: Supports are generally unnecessary for the base and fittings when the recommended print orientation is used. Apply build-plate-only supports where specific overhangs require them.
Quick Assembly Guide
Mount the wall bracket. Secure the bracket to an outdoor post or wall using M4 countersunk screws.
Install the electronics. Fasten the control board to the interior standoffs inside the base using M3 screws. Route the cables through the side and rear ports.
Seal the enclosure. Snap the solid lid onto the base. The crush ribs lock it into a snug, weather-resistant friction fit.
Deploy the wet zone. Mount the side_caddy nearby. Push a 4 mm PVC tube through the 4.3 mm snorkel hole, then seal the base with silicone adhesive. Screw the filled 1.5 L PET bottle into the caddy.
Connect the valve and fittings. Secure the WSV-12V solenoid valve using the solenoid_holder or solenoid_inline_valve. Connect the watering lines using the modular straight, curved, or elbow fittings.

<img width="2535" height="1365" alt="image" src="https://github.com/user-attachments/assets/de78493c-4504-4c31-a33b-3862e4823bd9" />
