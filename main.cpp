#include <iostream>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <vector>
#include <stdlib.h>

using namespace std;

void delete_files(vector<string> &dirlist)
{
    vector<string>::iterator iter;
    cout << "Deleting...";
    for(iter=dirlist.begin(); iter!=dirlist.end(); iter++)
    {
        string full_path_name = *iter;
        string command = "rm -f " + full_path_name;
        system(command.c_str());
    }
    cout << "Done!" << endl;
}

void exec(vector<string> &dirlist)
{
    vector<string>::iterator iter;
    int len = dirlist.size();
    int i;
    for(i=0, iter=dirlist.begin(); iter!=dirlist.end(); i++, iter++)
    {
        string full_path_name = *iter;
        string directory;
        string command, commandcd;
        string exec;

        int pos = full_path_name.find_last_of('/');
        directory = full_path_name.substr(0, pos);
        exec = full_path_name.substr(pos+1);

        cout << "Running " << i+1 << "/" << len << "...";
        commandcd = "cd " + directory + ";";
        cout << "\n" << command << endl;
        command = commandcd + "sudo ./" + exec;
        system(command.c_str());
        cout << "Done!" << endl;
    }
}

bool checkpermission(vector<string> &dirlist)
{
    vector<string>::iterator iter;
    for(iter=dirlist.begin(); iter!=dirlist.end(); iter++)
    {
        string full_path_name = *iter;
        if(chmod(full_path_name.c_str(), S_IXGRP) == -1)
            return false;
    }
    return true;
}

void copyexec(vector<string> &dirlist)
{
    vector<string>::iterator iter;
    for(iter=dirlist.begin(); iter!=dirlist.end(); iter++)
    {
        string full_path_name = *iter;
        int pos = full_path_name.find_last_of('/');
        full_path_name = full_path_name.substr(0, pos);
        if(full_path_name.find("GEMC") != string::npos)
        {
            string command = "cp executable/GOMC_Serial_GEMC " + full_path_name;
            system(command.c_str());
            full_path_name += "/GOMC_Serial_GEMC";
        }
        else if(full_path_name.find("GCMC") != string::npos)
        {
            string command = "cp executable/GOMC_Serial_GCMC " + full_path_name;
            system(command.c_str());
            full_path_name += "/GOMC_Serial_GCMC";
        }
        else if(full_path_name.find("NVT") != string::npos)
        {
            string command = "cp executable/GOMC_Serial_NVT " + full_path_name;
            system(command.c_str());
            full_path_name += "/GOMC_Serial_NVT";
        }
        *iter = full_path_name;
    }
}

void listdir(vector<string> &out, const string &dname)
{
    DIR *dir;
    struct dirent *ent;
    struct stat st;

    dir = opendir(dname.c_str());
    while((ent = readdir(dir)) != NULL)
    {
        const string file_name = ent->d_name;
        const string full_file_name = dname + "/" + file_name;
        if(file_name[0] == '.')
            continue;
        if(stat(full_file_name.c_str(), &st) == -1)
            continue;
        const bool is_directory = (st.st_mode & S_IFDIR) != 0;
        if(is_directory)
            listdir(out, dname + "/" + file_name);
        if(file_name == "in.dat")
            out.push_back(full_file_name);
    }
    closedir(dir);
}

bool compare(vector<string> &out, const string &dname)
{
    DIR *dir;
    struct dirent *ent;
    struct stat st;

    dir = opendir(dname.c_str());
    while((ent = readdir(dir)) != NULL)
    {
        const string file_name = ent->d_name;
        const string full_file_name = dname + "/" + file_name;
        if (file_name == "GOMC_Serial_NVT" ||
            file_name == "GOMC_Serial_GCMC" ||
            file_name == "GOMC_Serial_GEMC")
            continue;
        if(file_name[0] == '.')
            continue;
        if(stat(full_file_name.c_str(), &st) == -1)
            continue;
        const bool is_directory = (st.st_mode & S_IFDIR) != 0;
        if(is_directory)
            compare(out, dname + "/" + file_name);
        else
        {
            char ch1, ch2;
            int flag = 0;

            FILE * fi;
            FILE * fo;
            fi = fopen(full_file_name.c_str(), "r");
            string original_file = full_file_name;
            int pos = original_file.find("tmp");
            original_file.replace(pos, 3, "output");
            fo = fopen(original_file.c_str(), "r");
            if(!fi)
            {
                cout << "Cannot open file for comparison: " << full_file_name << endl;
                exit(0);
            }
            if(!fo)
            {
                cout << "Cannot open file for comparison: " << original_file << endl;
                exit(0);
            }

            while (((ch1 = fgetc(fi)) != EOF) &&((ch2 = fgetc(fo)) != EOF))
            {
                if (ch1 == ch2) {
                    flag = 1;
                    continue;
                }
                else {
                    flag = 0;
                    break;
                }
            }
            if (flag == 0)
                return false;
        }
    }
    return true;
    closedir(dir);
}

bool file_exists(char const *fname)
{
    if(access(fname, F_OK) != -1)
        return true;
    else
        return false;
}

bool directory_exists(char const *dname)
{
    struct stat sb;
    if(stat(dname, &sb) == 0 && S_ISDIR(sb.st_mode))
        return true;
    else
        return false;
}

int main( int argc, char *argv[] )
{
    vector<string> directory_list;
    if(!directory_exists("executable") ||
       !file_exists("executable/GOMC_Serial_GCMC") ||
       !file_exists("executable/GOMC_Serial_NVT") ||
       !file_exists("executable/GOMC_Serial_GEMC"))
    {
        cout << "[ERROR] Cannot find all required executables.\n";
        cout << "\tMake sure you copy your executables into the \"executable\" folder and then run this program.\n";
        cout << "\tWe need the following executables:";
        cout << "\n\t* GOMC_Serial_GCMC";
        cout << "\n\t* GOMC_Serial_NVT";
        cout << "\n\t* GOMC_Serial_GEMC";
        return 0;
    }
    if(!directory_exists("inputs"))
    {
        cout << "Directory \"inputs\" does not exists.\nMake sure you copy your input files into the \"inputs\" folder (each in separate folder) and then run this program.\n";
        cout << "\tExample: \"inputs/test01\" should contain your files for test case 01.\n";
        cout << "\tExample: \"inputs/justanotherfolderwithdifferentname\" works as well.\n";
        return 0;
    }

    system("mkdir tmp");
    system("cp -r inputs/* tmp/");

    cout << "Listing test cases...";
    listdir(directory_list, "tmp");
    cout << "Done!" << endl;
    cout << "Found " << directory_list.size() << " cases!" << endl;
    cout << "Copying binary files...";
    //delete_files(directory_list);
    copyexec(directory_list);
    cout << "Done!" << endl;
    cout << "Checking execution permission...";
    if(!checkpermission(directory_list))
    {
        cout << "\nCouldn't change the mode of the file. Executing will fail.";
        cout << "Please give your files execution permission manually or run this program as sudo.\n";
        return 0;
    }
    cout << "Done!" << endl;
    cout << "Starting to execute simulations..." << endl;
    exec(directory_list);
    cout << "Execution is done!" << endl;

    if(compare(directory_list, "tmp"))
        cout << "Great News... Everything matches!" << endl;
    else
        cout << "Bad News... Unfortunately something didn't match!" << endl;
    system("rm -rf tmp");
    return 0;
}
