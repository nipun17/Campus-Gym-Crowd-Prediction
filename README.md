# Campus-Gym-Crowd-Prediction
Campus Gyms have limited number of workout equipment, to find a perfect time slot when gym is less crowded is challenging.   
The objective is to predict how much crowded the Gym is at given point of time  and what are the factors affecting number of people using the gym.  
Predicting how crowded gym will be in future and accordingly can be used by the students at the campus.

The dataset consists of 26,000 people counts (about every 10 minutes) over the last year. 

62,000+ observations has been collected which also includes weather and semester-specific information that might affect how crowded it is. 

The label is the number of people, which is to be predicted from the given some subset of the features and it is the dependent variable.

The independent variables in the data-set are as follows:

           date (string; datetime of data)
           
           timestamp (int; number of seconds since beginning of day)
           
           dayofweek (int; 0 [monday] - 6 [sunday])
           
           is_weekend (int; 0 or 1) [boolean, if 1, it's either saturday or sunday, otherwise 0]
           
           is_holiday (int; 0 or 1) [boolean, if 1 it's a federal holiday, 0 otherwise]
           
           temperature (float; degrees fahrenheit)
           
           isstartof_semester (int; 0 or 1) [boolean, if 1 it's the beginning of a school semester, 0 otherwise]
           
           month (int; 1 [jan] - 12 [dec])
           
           hour (int; 0 - 23)
