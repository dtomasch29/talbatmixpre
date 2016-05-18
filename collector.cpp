#include<string>
#include<fstream>
#include<iostream>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(int argc, char *argv[])
{
  std::string line_ ;
  std::string *values=0;
  int levelH = atoi(argv[1]);
  int levelL = atoi(argv[2]);
  int maxIter = atoi(argv[3]);
  int TOL = atoi(argv[4]);
  int i = 0;
// read file
  values = new std::string [7];
  char filename[64];
  sprintf(filename, "lvl%d-%d-miter%d-tol%d/output.data" , levelH, levelL, maxIter, TOL);
  std::cout << "open file " << filename << " ..." << std::endl;
//  char syscommand[1024];
//  sprintf(syscommand, "ssh -p 2222 -i ~/.ssh/icarus-client-root -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@icarus-%d 'cat /sys/devices/virtual/thermal/thermal_zone*/temp' > ~/logs_nodes/log_node_%d", k, k);
//  int checkERR = system(syscommand);
  std::ifstream file_(filename);
  if(file_.is_open())
  {
    while(std::getline(file_,line_))
    {
      values[i] = line_;
      i++;
    }
    file_.close();
  }
    else
    std::cout << "ERROR! File "<< filename << " couldn't be opened!" << std::endl;
  // append to file
  std::string test;
  char filename2[64];
  sprintf(filename2, "level_%d.data" , levelH);
  std::cout << "read data and append to file " << filename2 << std::endl;
  std::ofstream myfile;
  myfile.open (filename2, std::ios_base::app);
  for (int j(0) ; j< i ; j++)
  {
      if(j==1)
      {
         std::string test1 = values[j];
         test1.erase(0,11);
         myfile << test1 ;
         myfile << " ";
      }
      if(j==3)
      {
         std::string test2 = values[j];
         test2.erase(0,6);
         myfile << test2 ;
         myfile << " ";
      }
      if(j==5)
      {
         std::string test3 = values[j];
         test3.erase(0,10);
         myfile << test3 ;
         myfile << " ";
      }
      if(j==6)
      {
         std::string test4 = values[j];
         test4.erase(0,10);
         myfile << test4 ;
         myfile << "\n";
      }
      else
      {
          std::cout << "Hier koennte ihre Werbung stehen 3===D" << std::endl;
      }
  }
  myfile.close();

delete[] values;
return 0;
}
