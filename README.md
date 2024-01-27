# *_Please send any request to Github (See Source URL!)_*
This mod provides a new item, the Logistic Train Scheduler (lts), that allows to handle automatically scheduler for trains

# How to use:
1- Configure the lts, in 2 parts
  - Left side to configure when the scheduler should apply to the train
  - Right side to configure the scheduler to apply to the train

2- Connect the lts
  - Input of the lts is used to check if condition is fulfilled to apply the scheduler
  - Output shall be connected to any train station (works as well with custom train stations)
  __NOTA: every train station connected to the same network as the lts will apply the scheduler. Even if train stops are not directly connected to the lts__

3- Then what: When a train stops at a train station connected to the lts, and if conditions are fulfilled, the scheluder set into the lts will be set for this train.
__NOTA 1:The lts scheduler replaces any existing scheduler in the train__  
__NOTA 2:If the condition for activation happens AFTER the train stopped at the station, the scheduler won't apply__  