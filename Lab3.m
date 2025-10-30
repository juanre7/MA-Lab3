%% Lab 3: Frequency-Domain Filtering with fft2
% Course: Mathematical Algorithms (DSP) - Image Processing Labs
% -------------------------------------------------------------------------
% - Ideal LP causes ringing (Gibbs) due to hard cutoff.
% - Convolution theorem: spatial convolution <-> frequency multiplication.
% - Compare spatial vs frequency-domain Gaussian LP (should match closely).
% HOW TO SUBMIT: include screenshots and short explanations for each section in the GitHub. Submit only the GitHub URL.
% -------------------------------------------------------------------------
close all; clear; clc;

if exist('peppers.png','file')
    I0 = imread('peppers.png');
else
    I0 = repmat(imread('cameraman.tif'),1,1,3);
end
I = im2double(rgb2gray(I0));
[M,N] = size(I);

%% 1) Magnitude spectrum (log-scale)
F = fft2(I);
Fshift = fftshift(F);
S = log(1 + abs(Fshift));
figure;
subplot(1,2,1); imshow(I,[]); title('Image');
subplot(1,2,2); imshow(S,[]); title('Log-magnitude spectrum (centered)');

%% 2) Ideal & Gaussian Low-pass in frequency
% Frequency grids centered at zero
[u,v] = meshgrid( (-floor(N/2)):(ceil(N/2)-1), (-floor(M/2)):(ceil(M/2)-1) );
D = sqrt(u.^2 + v.^2);

D0 = 40; % cutoff radius (ideal low-pass)
H_ideal_LP = double(D <= D0); % ideal circular LP

sigma = 20; % standard deviation for Gaussian in frequency
H_gauss_LP = exp(-(D.^2) / (2*sigma^2));

%% 3) Apply LP filters in frequency domain
G_ideal = ifft2( ifftshift( H_ideal_LP .* Fshift ) );
G_gauss = ifft2( ifftshift( H_gauss_LP .* Fshift ) );

% Scale to [0,1] for display in montage
G_ideal_img = mat2gray(real(G_ideal));
G_gauss_img = mat2gray(real(G_gauss));

figure; montage({I, G_ideal_img, G_gauss_img}, 'Size', [1 3]);
title('Original | Ideal LP | Gaussian LP (ringing vs smooth)');

%% 4) High-pass via complement
H_gauss_HP = 1 - H_gauss_LP;
G_hp = real( ifft2( ifftshift( H_gauss_HP .* Fshift ) ) );
G_hp = mat2gray(G_hp);

figure; montage({I, G_hp}, 'Size', [1 2]);
title('Original | Gaussian High-pass result');

%% 5) Compare spatial vs frequency-domain Gaussian LP
% Spatial Gaussian (LP = low-pass, paso bajo)
g1d = fspecial('gaussian',[1 7], 1.2);
I_spatial_gauss = imfilter(I, g1d'*g1d, 'replicate');

figure; montage({I_spatial_gauss, G_gauss_img}, 'Size', [1 2]);
title('Spatial Gaussian LP | Frequency-domain Gaussian LP');

%% 6) Reflections
% 1) Why does ideal LP cause ringing (Gibbs phenomenon)?
% 2) What does fftshift do visually?
% 3) When is frequency-domain filtering computationally preferable?
