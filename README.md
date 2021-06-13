# SpecularBRDF

SpecularBRDF is a shader that implemented Cook-Torrance BRDF in the Built-in Pipeline.
This BRDF that uses below common form is the lighting model announced by Robert L. Cook and Kenneth E. Torrance. (BRDF, Bidirectional Reflectance Distribution Function, is a function that defines how light is reflected at an opaque surface)

f(l,v) = ( D(h) * F(v,h) * G(l,v,h) ) / ( 4 * (n⋅l)* (n⋅v) )

l : light direction
v : view direction
h : half vector
n : normal vector

This formula consists of Distribution term, Fresnel term and Geometric term.
The Fresnel term was written using Schlick approximation.
Distribution term was written using GGX Trowbridge-Reitz form.
Geometric term was using Implicit, Neumann, Kelemen and Smith form.