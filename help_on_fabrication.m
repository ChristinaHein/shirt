function help_on__fabrication(human, pattern)

disp('-----------------------------------------------------------------');
disp('Please answer the following questions to get all help you need for the production of your tailor-made shirt.');
fprintf('Note: The following recommended suppliers are located in Germany.\n');
%% user input
% Fabric
fabric = input('Material: Do you already hava a Jersey fabric? (yes/no): ','s');
while sum(strcmp(fabric, {'yes','no'})) == 0
    warning('Invalid input. Please enter yes or no.')
    fabric = input('Do you already hava a Jersey fabric? (yes/no):','s');
end
 
% Cutting
cut = input('Cutting: Do you want to cut the fabric yourself or place an external order? (self,order): ','s');
while sum(strcmp(cut, {'self','order'})) == 0
    warning('Invalid input. Please enter self or order.')
    cut = input('Cutting: Do you want to cut the fabric yourself or place an external order? (self,order): ','s');
end

% Sewing
sew = input('Sewing: Do you want to sew the shirt yourself or place an external order? (self,order): ','s');
while sum(strcmp(sew, {'self','order'})) == 0
    warning('Invalid input. Please enter self or order.')
    sew = input('Sewing: Do you want to sew the shirt yourself or place an external order? (self,order): ','s');
end

if strcmp(cut,'order') && strcmp(sew,'order')
    fprintf('You have two choices: You can have all tasks (cutting and sewing) done by one external supplier \nor you can have cutting and sewing done by two different suppliers to save money.\n')
    order = input('Would you like the convenient way (ONE supplier) or the cheap way (TWO suppliers)? (one/two): ','s'); 
    while sum(strcmp(order, {'one','two'})) == 0
        warning('Invalid input. Please enter one or two.')
        fabric = input('Would you like the convenient way (ONE supplier) or the cheap way (TWO suppliers)? (one/two): ','s');
    end
end

% adress
if strcmp(cut,'order') ||strcmp(sew,'order')
    disp('-----------------------------------------------------------------');
    disp('Thank you. In order to prepare your order letters please insert your personal data:')
    name = input('Name: ','s');
    institution = input('Institution: ','s');
    street = input('Street and house number: ','s');
    city = input('ZIP and city: ','s');
    %telephone = input('Telephone number: ','s');
end
%% Give help and create all necessary files
disp('-----------------------------------------------------------------');
if strcmp(fabric,'N')
    disp('Your web broser opens a page where you can order your fabric. You need approximately 2 m for one shirt');
    url = 'https://www.aktivstoffe.de/baumwolle/baumwoll-jersey/uni/oeko-tex-jersey.html';
    web(url);
end

disp('-----------------------------------------------------------------');
switch cut
    case 'self'
        directory = create_production_files_lc(human, pattern);
        fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);
        switch sew
            case 'self'
                % Tutorial cutting and sewing
                %disp('You can use them to directly cut the fabric with a laser cutter. A tutorial can be found in the same folder');
                fprintf('A tutorial for cutting and sewing is currently being prepared and is avaiable soon.\n')
            case 'order'
                % Tutorial Cutting
                fprintf('A tutorial for cutting is currently being prepared and is avaiable soon.\n')
                % Label adress
                filename = fullfile(directory, 'Adress_tailor.txt');
                fid = fopen(filename,'w');
                fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen');
                fclose(fid);
                % order letter
                filename = fullfile(directory, 'Order_tailor.txt');
                fid = fopen(filename,'w');
                fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen \n\n\n');
                fprintf(fid,'Sehr geehrte Frau Altenburger,\n\nbitte naehen Sie aus den angefuegten Schnittmusterteilen ein Shirt.\n');
                fprintf(fid,'Das fertige Shirt senden Sie bitte an: \n   %s\n   %s\n   %s\n   %s\n\n',institution, name,street,city);
                fprintf(fid,'Mit freundlichen Gruessen\n%s',name);
                fclose(fid);
                % Print instructions
                fprintf('Please send the cut parts to the tailor (including return postage) or hand them in personally.\n');
                fprintf('A label with the adress and a order letter was created. The opening hours are Thu-Fri 9:00am - 17:00pm.\n');
                fprintf('The estimated costs for sewing are 30€.\n');                
        end
    case 'order'
        directory = create_production_files_ep(human, pattern);
        fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);
        % Label adress
        filename = fullfile(directory, 'Adress_cutting.txt');
        fid = fopen(filename,'w');
        fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach');
        fclose(fid);
        
        switch sew
            case 'self'
                % order E-Mail
                filename = fullfile(directory, 'Order_mail_cutting.txt');
                fid = fopen(filename,'w');
                fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach \n\n\n');
                fprintf(fid,'Sehr geehrter Herr Waldmann,\n\nbitte schneiden Sie angefuegtem Schnittmusterplan die Teile aus Jersey (separat gesendet) zu.\n');
                fprintf(fid,'Das zugeschnittenen Teile senden Sie bitte an: \n   %s\n   %s\n   %s\n   %s\n\n',institution, name,street,city);
                fprintf(fid,'Mit freundlichen Gruessen\n%s',name);
                fprintf(fid,'\n\n Anlage: Zuschneideplan als dxf-Datei',name);
                fclose(fid);
                % Tutorial sewing
                fprintf('A tutorial for sewing is currently being prepared and is avaiable soon.\n')
                % Print instructions
                fprintf('Please send the fabric to waldmann-textech.\n');
                fprintf('A label with the adress, the pattern as dxf-file and a order E-Mail was created. \n');
                fprintf('The estimated costs for cutting are 75€.\n');
                fprintf('A tutorial for sewing is currently being prepared and is avaiable soon.\n')
            case 'order'
                switch order
                    case 'one'
                        % order E-Mail
                        filename = fullfile(directory, 'Order_mail_cutting_sewing.txt');
                        fid = fopen(filename,'w');
                        fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach \n\n\n');
                        fprintf(fid,'Sehr geehrter Herr Waldmann,\n\nbitte schneiden Sie angefuegtem Schnittmusterplan die Teile aus Jersey (separat gesendet) zu\n');
                        fprintf(fid, 'und naehen Sie daraus ein Shirt.\n');
                        fprintf(fid,'Das fertige Shirt senden Sie bitte an: \n   %s\n   %s\n   %s\n   %s\n\n',institution, name,street,city);
                        fprintf(fid,'Mit freundlichen Gruessen\n%s',name);
                        fprintf(fid,'\n\n Anlage: Zuschneideplan als dxf-Datei',name);
                        fclose(fid);
                        % Print instructions
                        fprintf('Please send the fabric to waldmann-textech.\n');
                        fprintf('A label with the adress, the pattern as dxf-file and a order E-Mail was created. \n');
                        fprintf('The estimated costs for cutting and sewing are 250€.\n');
                    case 'two'
                        % order E-Mail cutting
                        filename = fullfile(directory, 'Order_mail_cutting.txt');
                        fid = fopen(filename,'w');
                        fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach \n\n\n');
                        fprintf(fid,'Sehr geehrter Herr Waldmann,\n\nbitte schneiden Sie angefügtem Schnittmusterplan die Teile aus Jersey (separat gesendet) zu.\n');
                        fprintf(fid,'Das zugeschnittenen Teile senden Sie bitte an: \n   %s\n   %s\n   %s\n   %s\n\n',institution, name,street,city);
                        fprintf(fid,'Mit freundlichen Gruessen\n%s',name);
                        fprintf(fid,'\n\n Anlage: Zuschneideplan als dxf-Datei',name);
                        fclose(fid);
                        % Label adress
                        filename = fullfile(directory, 'Adress_tailor.txt');
                        fid = fopen(filename,'w');
                        fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen');
                        fclose(fid);
                        % order letter
                        filename = fullfile(directory, 'Order_tailor.txt');
                        fid = fopen(filename,'w');
                        fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen \n\n\n');
                        fprintf(fid,'Sehr geehrte Frau Altenburger,\n\nbitte naehen Sie aus den angefuegten Schnittmusterteilen ein Shirt.\n');
                        fprintf(fid,'Das fertige Shirt senden Sie bitte an: \n   %s\n   %s\n   %s\n   %s\n\n',institution, name,street,city);
                        fprintf(fid,'Mit freundlichen Gruessen\n%s',name);
                        fclose(fid);
                        % Print instructions
                        fprintf('Step 1: Please send the fabric to waldmann-textech.\n');
                        fprintf('A label with the adress, the pattern as dxf-file and a order E-Mail was created. \n');
                        fprintf('Step 2: As soon as you receive the cutted parts please send the cut parts to the tailor (including return postage) or hand them in personally.\n');
                        fprintf('A label with the adress and a order letter was created. The opening hours are Thu-Fri 9:00am - 17:00pm.\n');
                        fprintf('The estimated costs  are 75€ for cutting and 30€ for sewing.\n');
                end
        end
end
        
    
    
    
    