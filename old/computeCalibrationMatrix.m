function K = computeCalibrationMatrix(v1, v2, h1, h2)
    % Computes the calibration matrix K given vanishing points and vertical lines
    % Inputs:
    %   - v1, v2: Vanishing points in the horizontal directions (X and Y)
    %   - h1, h2: Vertical line equations in the image plane
    % Output:
    %   - K: Calibration matrix

    % Step 1: Define constraints for intrinsic parameters
    % K^(-T) * w * K^(-1) = 0, where w = [1 0 0; 0 1 0; 0 0 0] (image of absolute conic)
    syms f x0 y0 real; % Focal length and principal point coordinates
    w = [1, 0, -x0; 0, f^2, -f^2*y0; -x0, -f^2*y0, x0^2 + f^2*y0^2 - f^2];

    % Step 2: Constraints from orthogonality between horizontal vanishing points
    v1 = v1(:); v2 = v2(:); % Ensure column vectors
    constraint1 = v1' * w * v2;

    % Step 3: Constraints from vertical lines (orthogonal to the vanishing line)
    v_line = cross(h1, h2); % Vanishing line of the vertical plane
    constraint2 = v_line' * w * v_line;

    % Step 4: Solve for intrinsic parameters
    eqs = [constraint1 == 0, constraint2 == 0];
    sol = solve(eqs, [f, x0, y0]);

    % Extract solutions
    f_val = double(sol.f);
    x0_val = double(sol.x0);
    y0_val = double(sol.y0);

    % Step 5: Construct the calibration matrix K
    K = [f_val, 0, x0_val; 
         0, f_val, y0_val; 
         0, 0, 1];
end
