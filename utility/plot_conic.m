function [X, Y] = plot_conic(C, t)
    % Decompose the conic matrix into standard quadratic form: Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
    A = C(1, 1); 
    B = 2 * C(1, 2); 
    C_ = C(2, 2); 
    D = 2 * C(1, 3); 
    E = 2 * C(2, 3); 
    F = C(3, 3);
    
    % Convert to an ellipse-centered form using eigenvalue decomposition
    M = [A, B/2; B/2, C_]; % Quadratic coefficients matrix
    [eigVec, eigVal] = eig(M);
    
    % Semi-axes lengths (inverse square roots of eigenvalues)
    semi_axes = sqrt(-F ./ diag(eigVal));
    
    % Center of the conic
    center = -0.5 * inv(M) * [D; E];
    
    % Rotation angle (orientation of the conic)
    theta = atan2(eigVec(2, 1), eigVec(1, 1));
    
    % Generate ellipse points
    X = semi_axes(1) * cos(t);
    Y = semi_axes(2) * sin(t);
    
    % Rotate and translate the points to the correct position
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    points = R * [X; Y];
    
    X = points(1, :) + center(1);
    Y = points(2, :) + center(2);
end