classdef testApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        Button              matlab.ui.control.Button
        EditField_eyeGlobeRadius_true        matlab.ui.control.EditField
        EditField_eyeGlobeRadius_max        matlab.ui.control.EditField
        EditField_eyeGlobeRadius_min        matlab.ui.control.EditField
        EditField_eyeGlobeRadius_startingPoint        matlab.ui.control.EditField
        CheckBox_eyeGlobeRadius          matlab.ui.control.CheckBox
        EditField_eyeGlobePosY_true        matlab.ui.control.EditField
        EditField_eyeGlobePosY_max        matlab.ui.control.EditField
        EditField_eyeGlobePosY_min        matlab.ui.control.EditField
        EditField_eyeGlobePosY_startingPoint        matlab.ui.control.EditField
        CheckBox_eyeGlobePosY          matlab.ui.control.CheckBox
        EditField_eyeGlobePosX_true        matlab.ui.control.EditField
        EditField_eyeGlobePosX_max        matlab.ui.control.EditField
        EditField_eyeGlobePosX_min        matlab.ui.control.EditField
        EditField_eyeGlobePosX_startingPoint         matlab.ui.control.EditField
        CheckBox_eyeGlobePosX          matlab.ui.control.CheckBox
        EditField_camBeta_true         matlab.ui.control.EditField
        EditField_camBeta_max         matlab.ui.control.EditField
        EditField_camBeta_min         matlab.ui.control.EditField
        EditField_camBeta_startingPoint         matlab.ui.control.EditField
        CheckBox_camBeta          matlab.ui.control.CheckBox
        TrueValueLabel      matlab.ui.control.Label
        EditField_camAlpha_true         matlab.ui.control.EditField
        MaxValueLabel       matlab.ui.control.Label
        EditField_camAlpha_max         matlab.ui.control.EditField
        MinValueLabel       matlab.ui.control.Label
        EditField_camAlph_min         matlab.ui.control.EditField
        StartingValueLabel  matlab.ui.control.Label
        EditField_camAlpha_startingPoint           matlab.ui.control.EditField
        CheckBox_camAlpha            matlab.ui.control.CheckBox
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 538 468];
            app.UIFigure.Name = 'MATLAB App';

            % Create CheckBox
            app.CheckBox_camAlpha = uicheckbox(app.UIFigure);
            app.CheckBox_camAlpha.Position = [29 380 111 36];

            % Create EditField
            app.EditField_camAlpha_startingPoint = uieditfield(app.UIFigure, 'text');
            app.EditField_camAlpha_startingPoint.Position = [219 380 80 36];

            % Create StartingValueLabel
            app.StartingValueLabel = uilabel(app.UIFigure);
            app.StartingValueLabel.HorizontalAlignment = 'center';
            app.StartingValueLabel.Position = [219 423 80 25];
            app.StartingValueLabel.Text = 'Starting Value';

            % Create EditField_2
            app.EditField_camAlph_min = uieditfield(app.UIFigure, 'text');
            app.EditField_camAlph_min.Position = [311 380 80 36];

            % Create MinValueLabel
            app.MinValueLabel = uilabel(app.UIFigure);
            app.MinValueLabel.HorizontalAlignment = 'center';
            app.MinValueLabel.Position = [311 423 80 25];
            app.MinValueLabel.Text = 'Min Value';

            % Create EditField_3
            app.EditField_camAlpha_max = uieditfield(app.UIFigure, 'text');
            app.EditField_camAlpha_max.Position = [408 380 80 36];

            % Create MaxValueLabel
            app.MaxValueLabel = uilabel(app.UIFigure);
            app.MaxValueLabel.HorizontalAlignment = 'center';
            app.MaxValueLabel.Position = [408 423 80 25];
            app.MaxValueLabel.Text = 'Max Value';

            % Create EditField_4
            app.EditField_camAlpha_true = uieditfield(app.UIFigure, 'text');
            app.EditField_camAlpha_true.Position = [124 380 80 36];

            % Create TrueValueLabel
            app.TrueValueLabel = uilabel(app.UIFigure);
            app.TrueValueLabel.HorizontalAlignment = 'center';
            app.TrueValueLabel.Position = [124 423 80 25];
            app.TrueValueLabel.Text = 'True Value';

            % Create CheckBox_2
            app.CheckBox_camBeta = uicheckbox(app.UIFigure);
            app.CheckBox_camBeta.Position = [29 325 111 36];

            % Create EditField_5
            app.EditField_camBeta_startingPoint = uieditfield(app.UIFigure, 'text');
            app.EditField_camBeta_startingPoint.Position = [219 325 80 36];

            % Create EditField_6
            app.EditField_camBeta_min = uieditfield(app.UIFigure, 'text');
            app.EditField_camBeta_min.Position = [311 325 80 36];

            % Create EditField_7
            app.EditField_camBeta_max = uieditfield(app.UIFigure, 'text');
            app.EditField_camBeta_max.Position = [408 325 80 36];

            % Create EditField_8
            app.EditField_camBeta_true = uieditfield(app.UIFigure, 'text');
            app.EditField_camBeta_true.Position = [124 325 80 36];

            % Create CheckBox_3
            app.CheckBox_eyeGlobePosX = uicheckbox(app.UIFigure);
            app.CheckBox_eyeGlobePosX.Position = [29 274 111 36];

            % Create EditField_9
            app.EditField_eyeGlobePosX_startingPoint = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosX_startingPoint.Position = [219 274 80 36];

            % Create EditField_10
            app.EditField_eyeGlobePosX_min = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosX_min.Position = [311 274 80 36];

            % Create EditField_11
            app.EditField_eyeGlobePosX_max = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosX_max.Position = [408 274 80 36];

            % Create EditField_12
            app.EditField_eyeGlobePosX_true = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosX_true.Position = [124 274 80 36];

            % Create CheckBox_4
            app.CheckBox_eyeGlobePosY = uicheckbox(app.UIFigure);
            app.CheckBox_eyeGlobePosY.Position = [29 222 111 36];

            % Create EditField_13
            app.EditField_eyeGlobePosY_startingPoint = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosY_startingPoint.Position = [219 222 80 36];

            % Create EditField_14
            app.EditField_eyeGlobePosY_min = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosY_min.Position = [311 222 80 36];

            % Create EditField_15
            app.EditField_eyeGlobePosY_max = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosY_max.Position = [408 222 80 36];

            % Create EditField_16
            app.EditField_eyeGlobePosY_true = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobePosY_true.Position = [124 222 80 36];

            % Create CheckBox_5
            app.CheckBox_eyeGlobeRadius = uicheckbox(app.UIFigure);
            app.CheckBox_eyeGlobeRadius.Position = [29 163 111 36];

            % Create EditField_17
            app.EditField_eyeGlobeRadius_startingPoint = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobeRadius_startingPoint.Position = [219 163 80 36];

            % Create EditField_18
            app.EditField_eyeGlobeRadius_min = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobeRadius_min.Position = [311 163 80 36];

            % Create EditField_19
            app.EditField_eyeGlobeRadius_max = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobeRadius_max.Position = [408 163 80 36];

            % Create EditField_20
            app.EditField_eyeGlobeRadius_true = uieditfield(app.UIFigure, 'text');
            app.EditField_eyeGlobeRadius_true.Position = [124 163 80 36];

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.Position = [139 62 270 55];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = testApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end