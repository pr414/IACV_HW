This project completes the Homework for the course "Image Analysis and Computer Vision" held in Politecnico di Milano for the A.Y. 2024/25.
It is composed of the following:

Theory:
1. From the 𝒍𝒊 and 𝒎𝒋 lines, find the vanishing line 𝒍′∞ of the horizontal plane.
2. Using the results of the previous point, find a (Euclidean) rectification mapping 𝑯𝑹 for a horizontal plane (e.g., the lower horizontal face of the parallelepiped), and compute the depth 𝒎 of the parallelepiped.
3. From the results of the previous points, use the lines 𝒉𝒊 to find the calibration matrix K.
4. Using the results of the previous points, determine the height 𝒉 of the parallelepiped.
5. Using 𝑺 and the results of previous points, compute the X-Y coordinates of a dozen points (at your choice) of the unknown horizontal curve.
6. Using K, localize the camera with respect to the parallelepiped.

Matlab:
1. Consider the image Look-outCat.png. Using feature extraction techniques plus possible manual intervention, extract the images of useful lines and both the image 𝑪, of the circumference and the image 𝑺 of the other planar curve.
2. Write a Matlab program that implements the solutions to problems 1 – 6 and show the obtained results.
3. Plot the rectified curve 𝑺 and show different views of the recovered 3D model of the rectangular parallelepiped.

The Matlab implementation leaves room for improvement on the feature detection (Point 1) and Camera Localization (Point 2.6).
External functions to derive geometrical transformations are taken from the course material.
