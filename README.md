# Lab 3 — Frequency-Domain Filtering with `fft2`


## Overview

You will visualize the 2D Fourier magnitude spectrum, build ideal and Gaussian low-pass filters, apply them in the frequency domain, create a Gaussian high-pass via complement, and compare spatial vs frequency-domain Gaussian smoothing.


## 1) Input and preprocessing

Reads the color image if available, otherwise falls back to Cameraman. Converts to grayscale and rescales to `double` for FFT and display.


---

## 2) Log-magnitude spectrum (centered)

Computes `F = fft2(I)`, centers low frequencies with `fftshift(F)`, and displays `log(1 + |F|)` so the dynamic range is visible. Useful to see energy concentration and symmetry.

<img width="1045" height="367" alt="Figure_1" src="https://github.com/user-attachments/assets/eb3f6c4f-0035-4fb9-b065-05c4799df193" />

---

## 3) Ideal and Gaussian low-pass design

Builds a frequency grid around the origin and a radial distance map.

* Ideal LP: binary mask inside a cutoff radius. Sharp transition.
* Gaussian LP: smooth decay from the origin. Soft transition that reduces ringing.

*(This section defines filters. The visual results appear in the next section.)*

---

## 4) Apply LP filters in the frequency domain

Multiplies the centered spectrum by each LP filter, then reconstructs with `ifftshift` and `ifft2`. Displays a montage: Original, Ideal LP, Gaussian LP. Expect visible ringing with the ideal LP and smoother results with the Gaussian LP.

<img width="1045" height="290" alt="Figure_2" src="https://github.com/user-attachments/assets/9e75ff2b-0f3d-4561-b23c-910f28815bc7" />

---

## 5) Gaussian high-pass via complement

Forms a high-pass filter as `1 − H_gauss_LP`, applies it in frequency, and reconstructs. Enhances edges and fine details by suppressing low frequencies.

<img width="1045" height="420" alt="Figure_3" src="https://github.com/user-attachments/assets/6219b9dd-e753-4405-89ce-a3a4118ac63f" />

---

## 6) Spatial vs frequency-domain Gaussian LP

Creates a spatial Gaussian kernel with `fspecial('gaussian',[1 7], 1.2)`, applies it separably as `g1d' * g1d` using `imfilter` with `'replicate'` borders, and compares it to the frequency-domain Gaussian LP result. With consistent parameters, both should be very similar.

<img width="1045" height="420" alt="Figure_4" src="https://github.com/user-attachments/assets/d9f9ff09-0831-4a0d-8c98-3ec3baedeed0" />

---


