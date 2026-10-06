% Automated Data Cleaner
clear; clc;

% --- 1. Read the data ---
data = readtable('messy_weather_data.xlsx');
originalCount = height(data);   % number of rows loaded

% --- 2. Find rows with missing values ---
% ismissing marks each missing cell; any(...,2) checks across each row
missingRows = any(ismissing(data), 2);

% --- 3. Find rows with invalid values ---
% Each line gives true/false for every row
badTemp     = data.Temperature < -50 | data.Temperature > 130;
badHumidity = data.Humidity < 0 | data.Humidity > 100;
badRainfall = data.Rainfall < 0;

% --- 4. Combine all problems into one list ---
% A row is removed if it is missing OR has any invalid value
removeRows = missingRows | badTemp | badHumidity | badRainfall;

% --- 5. Remove the bad rows ---
cleanData = data(~removeRows, :);   % keep only rows that are NOT bad
cleanCount = height(cleanData);
removedCount = originalCount - cleanCount;

% --- 6. Calculate averages ---
if cleanCount > 0
    avgTemp     = mean(cleanData.Temperature);
    avgHumidity = mean(cleanData.Humidity);
    avgRainfall = mean(cleanData.Rainfall);
else
    avgTemp = NaN; avgHumidity = NaN; avgRainfall = NaN;
end

% --- 7. Display results ---
fprintf('Rows originally loaded: %d\n', originalCount);
fprintf('Rows removed: %d\n', removedCount);
fprintf('Rows remaining: %d\n', cleanCount);
fprintf('Average temperature: %.2f F\n', avgTemp);
fprintf('Average humidity: %.2f %%\n', avgHumidity);
fprintf('Average rainfall: %.2f\n', avgRainfall);

% --- 8. Save the cleaned table ---
writetable(cleanData, 'cleaned_weather_data.xlsx');
disp('Cleaned data saved to cleaned_weather_data.xlsx');