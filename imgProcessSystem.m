classdef imgProcessSystem < matlab.apps.AppBase


    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        ProcessStartButton            matlab.ui.control.Button
        LoadCustomImageButton         matlab.ui.control.Button
        LoadPredefinedImagesDropDown  matlab.ui.control.DropDown
        LoadPredefinedImagesDropDownLabel  matlab.ui.control.Label
        SyKnob                        matlab.ui.control.Knob
        SyKnobLabel                   matlab.ui.control.Label
        SxKnob                        matlab.ui.control.Knob
        SxKnobLabel                   matlab.ui.control.Label
        UIAxes                        matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        pepper
        cc
        fruits
        sx
        sy
    end
   

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadCustomImageButton
        function LoadCustomImageButtonPushed(app, event)
           switch app.LoadPredefinedImagesDropDown.Value
               case 'Peppers'
                    a = imread("Peppers.png");
                    b = rgb2gray(a);
                    app.pepper = im2double(b);
                    imshow(app.pepper,'Parent',app.UIAxes)
               case 'Coloured chips'
                    x = imread("cc.png");
                    y = rgb2gray(x);
                    app.cc = im2double(y);
                    imshow(app.cc,'Parent',app.UIAxes)
               case 'Fruits'
                    m = imread("Fruits.png");
                    n = rgb2gray(m);
                    app.fruits = im2double(n);
                    imshow(app.fruits,'Parent',app.UIAxes)
           end
        end

        % Value changed function: LoadPredefinedImagesDropDown
        function LoadPredefinedImagesDropDownValueChanged(app, event)
            value = app.LoadPredefinedImagesDropDown.Value;
            
        end

        % Button pushed function: ProcessStartButton
        function ProcessStartButtonPushed(app, event)
                      
            switch app.LoadPredefinedImagesDropDown.Value
                
                case 'Peppers'
                    Gx = [-1 1];
                    Gy = Gx';
                    Ix = conv2(app.pepper,Gx,'same');
                    Iy = conv2(app.pepper,Gy,'same');
        
                    edgeFIS = mamfis('Name','edgeDetection');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Ix');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Iy');
        
                    app.sx = app.SxKnob.Value;
                    app.sy =  app.SyKnob.Value;
        
                    edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[app.sx 0],'Name','zero');
                    edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[app.sy 0],'Name','zero');
        
                    edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');
                    wa = 0.1;
                    wb = 1;
                    wc = 1;
                    ba = 0;
                    bb = 0;
                    bc = 0.7;
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');
                                                   
                    r1 = "If Ix is zero and Iy is zero then Iout is white";
                    r2 = "If Ix is not zero or Iy is not zero then Iout is black";
                    edgeFIS = addRule(edgeFIS,[r1 r2]);
                    edgeFIS.Rules
                    Ieval = zeros(size(app.pepper));
                    for ii = 1:size(app.pepper,1)
                    Ieval(ii,:) = evalfis(edgeFIS,[(Ix(ii,:));(Iy(ii,:))]');
                    end
                
                case 'Coloured chips'
                    Gx = [-1 1];
                    Gy = Gx';
                    Ix = conv2(app.cc,Gx,'same');
                    Iy = conv2(app.cc,Gy,'same');
        
                    edgeFIS = mamfis('Name','edgeDetection');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Ix');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Iy');
        
                    app.sx = app.SxKnob.Value;
                    app.sy =  app.SyKnob.Value;
        
                    edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[app.sx 0],'Name','zero');
                    edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[app.sy 0],'Name','zero');
        
                    edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');
                    wa = 0.1;
                    wb = 1;
                    wc = 1;
                    ba = 0;
                    bb = 0;
                    bc = 0.7;
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');

                    r1 = "If Ix is zero and Iy is zero then Iout is white";
                    r2 = "If Ix is not zero or Iy is not zero then Iout is black";
                    edgeFIS = addRule(edgeFIS,[r1 r2]);
                    edgeFIS.Rules
                    Ieval = zeros(size(app.cc));
                    for ii = 1:size(app.cc,1)
                    Ieval(ii,:) = evalfis(edgeFIS,[(Ix(ii,:));(Iy(ii,:))]');
                    end
                    
                case 'Fruits'
                    Gx = [-1 1];
                    Gy = Gx';
                    Ix = conv2(app.fruits,Gx,'same');
                    Iy = conv2(app.fruits,Gy,'same');
        
                    edgeFIS = mamfis('Name','edgeDetection');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Ix');
                    edgeFIS = addInput(edgeFIS,[-1 1],'Name','Iy');
        
                    app.sx = app.SxKnob.Value;
                    app.sy =  app.SyKnob.Value;
        
                    edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[app.sx 0],'Name','zero');
                    edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[app.sy 0],'Name','zero');
        
                    edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');
                    wa = 0.1;
                    wb = 1;
                    wc = 1;
                    ba = 0;
                    bb = 0;
                    bc = 0.7;
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
                    edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');

                    r1 = "If Ix is zero and Iy is zero then Iout is white";
                    r2 = "If Ix is not zero or Iy is not zero then Iout is black";
                    edgeFIS = addRule(edgeFIS,[r1 r2]);
                    edgeFIS.Rules
                    Ieval = zeros(size(app.fruits));
                    for ii = 1:size(app.fruits,1)
                    Ieval(ii,:) = evalfis(edgeFIS,[(Ix(ii,:));(Iy(ii,:))]');
                    end

                    
            end                                
                imshow(Ieval,'Parent',app.UIAxes)
        end

        % Value changed function: SxKnob
        function SxKnobValueChanged(app, event)
            value = app.SxKnob.Value;
            
        end

        % Value changed function: SyKnob
        function SyKnobValueChanged(app, event)
            value = app.SyKnob.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            zlabel(app.UIAxes, ']')
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Box = 'on';
            app.UIAxes.Position = [162 163 444 304];

            % Create SxKnobLabel
            app.SxKnobLabel = uilabel(app.UIFigure);
            app.SxKnobLabel.HorizontalAlignment = 'center';
            app.SxKnobLabel.Position = [93 293 25 22];
            app.SxKnobLabel.Text = 'Sx';

            % Create SxKnob
            app.SxKnob = uiknob(app.UIFigure, 'continuous');
            app.SxKnob.Limits = [0.01 1];
            app.SxKnob.MajorTicks = [0.01 0.2 0.4 0.6 0.8 1];
            app.SxKnob.ValueChangedFcn = createCallbackFcn(app, @SxKnobValueChanged, true);
            app.SxKnob.Position = [74 349 60 60];
            app.SxKnob.Value = 0.01;

            % Create SyKnobLabel
            app.SyKnobLabel = uilabel(app.UIFigure);
            app.SyKnobLabel.HorizontalAlignment = 'center';
            app.SyKnobLabel.Position = [95 133 25 22];
            app.SyKnobLabel.Text = 'Sy';

            % Create SyKnob
            app.SyKnob = uiknob(app.UIFigure, 'continuous');
            app.SyKnob.Limits = [0.01 1];
            app.SyKnob.MajorTicks = [0.01 0.2 0.4 0.6 0.8 1];
            app.SyKnob.ValueChangedFcn = createCallbackFcn(app, @SyKnobValueChanged, true);
            app.SyKnob.Position = [76 189 60 60];
            app.SyKnob.Value = 0.01;

            % Create LoadPredefinedImagesDropDownLabel
            app.LoadPredefinedImagesDropDownLabel = uilabel(app.UIFigure);
            app.LoadPredefinedImagesDropDownLabel.HorizontalAlignment = 'right';
            app.LoadPredefinedImagesDropDownLabel.Position = [223 133 136 22];
            app.LoadPredefinedImagesDropDownLabel.Text = 'Load Predefined Images';

            % Create LoadPredefinedImagesDropDown
            app.LoadPredefinedImagesDropDown = uidropdown(app.UIFigure);
            app.LoadPredefinedImagesDropDown.Items = {'Peppers', 'Coloured chips', 'Fruits'};
            app.LoadPredefinedImagesDropDown.ValueChangedFcn = createCallbackFcn(app, @LoadPredefinedImagesDropDownValueChanged, true);
            app.LoadPredefinedImagesDropDown.Position = [374 133 100 22];
            app.LoadPredefinedImagesDropDown.Value = 'Peppers';

            % Create LoadCustomImageButton
            app.LoadCustomImageButton = uibutton(app.UIFigure, 'push');
            app.LoadCustomImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadCustomImageButtonPushed, true);
            app.LoadCustomImageButton.Position = [287 86 124 23];
            app.LoadCustomImageButton.Text = 'Load Custom Image';

            % Create ProcessStartButton
            app.ProcessStartButton = uibutton(app.UIFigure, 'push');
            app.ProcessStartButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessStartButtonPushed, true);
            app.ProcessStartButton.Position = [45 85 126 23];
            app.ProcessStartButton.Text = 'Process Start Button';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = imgProcessSystem

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

