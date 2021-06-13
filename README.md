# SpecularBRDF

SpecularBRDF is a shader that implemented Cook-Torrance BRDF in the Built-in Pipeline.
This BRDF that uses below common form is the lighting model announced by Robert L. Cook and Kenneth E. Torrance. (BRDF, Bidirectional Reflectance Distribution Function, is a function that defines how light is reflected at an opaque surface)

f(l,v) = ( D(h) * F(v,h) * G(l,v,h) ) / ( 4 * (n⋅l)* (n⋅v) )

- l : light direction
- v : view direction
- h : half vector
- n : normal vector

This formula consists of Distribution term, Fresnel term and Geometric term.
The Fresnel term was written using Schlick approximation.
Distribution term was written using GGX Trowbridge-Reitz form.
Geometric term was using Implicit, Neumann, Kelemen and Smith form.

## Roughness

### 0.2
implicit   
<img src="https://user-images.githubusercontent.com/217529/121791873-a93ced80-cc29-11eb-87a5-ae49ab40453a.png" width="40%">

kelemen   
<img src="https://user-images.githubusercontent.com/217529/121791876-ab9f4780-cc29-11eb-9f6c-172d9e3e5c77.png" width="40%">

neumann   
<img src="https://user-images.githubusercontent.com/217529/121791879-ac37de00-cc29-11eb-9e6a-30b4fabd8b57.png" width="40%">

### 0.5
implicit   
<img src="https://user-images.githubusercontent.com/217529/121791874-aa6e1a80-cc29-11eb-97b5-58e3144550f4.png" width="40%">

kelemen   
<img src="https://user-images.githubusercontent.com/217529/121791877-ab9f4780-cc29-11eb-8f5d-9db784dde0d3.png" width="40%">

neumann   
<img src="https://user-images.githubusercontent.com/217529/121791880-acd07480-cc29-11eb-9f34-547da6158c16.png" width="40%">

### 1.0
implicit   
<img src="https://user-images.githubusercontent.com/217529/121791875-ab06b100-cc29-11eb-8227-1881aba92475.png" width="40%">

kelemen   
<img src="https://user-images.githubusercontent.com/217529/121791878-ac37de00-cc29-11eb-87a0-6978a08c2f00.png" width="40%">

neumann   
<img src="https://user-images.githubusercontent.com/217529/121791881-acd07480-cc29-11eb-9913-13e3e2f805a4.png" width="40%">

In case of using the form with neumann or smith geometry term, Some noises appear so it requires improvement.

## License   
[MIT License](https://raw.githubusercontent.com/wooram-yang/SpecularBRDF/master/LICENSE)
