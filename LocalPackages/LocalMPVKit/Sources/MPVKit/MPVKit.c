// This file exists to force Xcode to link the MoltenVK framework.
// Even though libmpv depends on it, SwiftPM/Xcode sometimes strips dynamic binary dependencies 
// of static libraries in Release builds if they appear unused by the wrapper code.

extern void vkCreateMetalSurfaceEXT(void);

__attribute__((used)) static void* _flux_force_link_moltenvk = (void*)vkCreateMetalSurfaceEXT;
