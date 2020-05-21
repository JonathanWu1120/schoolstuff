C++
make/make run
make run does everything
make cleanall gets rid of output files
There is an issue with the badImprovedGreedyInput.txt test case. In my program, it assumes that the given inputs are unsorted, and then sorts it from lowest to highest value. Then it reverses the vector containing the items and calls the greedy/backtracking algorithms. In the provided badImprovedGreedyInput.txt file, if the first item was 160 1280, the greedy2 algorithm would give the result 1280, but the greedy1 algorithm would provide 1600. This is why my output for badImprovedGreedy2 is 5 1600 instead of 5 1280.
I have done this assignment completely on my own. I have not copied it, nor have I given my solution to anyone else. I understand that if I am involved in plagiarism or cheating I will have to sign an official form that I have cheated and that this form will be stored in my official university record. I also understand that I will receive a grade of 0 for the involved assignment for my first offense and that I will receive a grade of “F” for the course for any additional offense.
