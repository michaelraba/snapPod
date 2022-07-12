# dir +

Papers that comment specifically on snapshot POD bzgl. fredholm integral equation setup and solution

## 1. SEN et al.
+ 5 stars: comments directly on snapshot procedure. That suggest, that if xcorr is used, then we must multiply that by r ...? At each $r$ ..? The integration is the shift.
---
1D POD decomposition in the wall-normal $(y)$ direction is performed to extract the three components of the 1D eigenfunction $\phi_{u}(y), \phi_{v}(y), \phi_{w}(y)$. 

Given the velocity profiles at all $(x, z)$ locations and at all times, the temporal correlation function between snapshots $t$ and $t^{\prime}$ is defined as

$$ C\left(t, t^{\prime}\right)=\frac{1}{N_{t}} \int_{y} u_{i}(y, t) u_{i}\left(y, t^{\prime}\right) \mathrm{d} y, \quad i=1,3.$$

The numerical evaluation of the above integral is performed using trapezoidal rule, similar to the approach of Moin and Moser [37]. The temporal correlation function $\left(C\left(t, t^{\prime}\right)\right)$ is then used as a kernel to formulate the eigenvalue problem:
$$ \int C\left(t, t^{\prime}\right) a^{n}\left(t^{\prime}\right) \mathrm{d} t^{\prime}=\lambda_{n} a^{n}(t).$$

Solution of the eigenvalue problem will result in the temporal coefficients (which are eigenvectors of the correlation tensor), $a^{n}(t)$, and eigenvalues, $\lambda^{n}$, for mode number $n$. 1D spatial eigenmodes are then calculated by projecting the temporal coefficients onto the velocity field as
$$\phi_{i}^{n}(y)=\sum_{p=1}^{N_{t}} a^{n}\left(t_{p}\right) u_{i}\left(y, t_{p}\right), \quad i=1,3 .$$

## 2. Sirisup et al 
+ 5 stars: Against, same stuff...
---
In the POD framework one can represent evolving flow fields in the form

$$\mathbf{u}(t, \mathbf{x})=\sum_{k} a_{k}(t) \boldsymbol{\phi}_{k}(\mathbf{x})$$

where is the basis extracted from the eigenvalue problem for the temporal modes,

$$\int_{A} C\left(t, t^{\prime}\right) a_{k}\left(t^{\prime}\right) \mathrm{d} t^{\prime}=\lambda_{k} a_{k}(t), \quad t \in A, \forall k$$

and $A$ is a specified time interval. Here $C\left(t, t^{\prime}\right)$ is the correlation function defined as

$$C\left(t, t^{\prime}\right)=\int_{\Omega} \mathbf{u}(t, \mathbf{x}) \cdot \mathbf{u}\left(t^{\prime}, \mathbf{x}\right) \mathrm{d} \mathbf{x}$$
The POD basis in space is determined by

$$\boldsymbol{\phi}_{k}(\mathbf{x})=\int_{A} a_{k}(t) \mathbf{u}(t, \mathbf{x}) \mathrm{d} t \quad \forall k$$
