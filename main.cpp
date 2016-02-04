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

void replace_char(string &str, char old, char new)
{
    int pos;
    while((pos = str.find_first_of(old)) != string::npos)
        str[pos] = new;
}

void copyexec(vector<string> &dirlist)
{
    vector<string>::iterator iter;
    for(iter=dirlist.begin(); iter!=dirlist.end(); iter++)
    {
        string full_path_name = *iter;
        int pos = full_path_name.find_last_of('/');
        full_path_name[pos] = 0;
        if(full_path_name.find("GEMC") != string::npos)
        {
            replace_char(full_path_name, '/', '\\');
            cout << full_path_name << endl;
            string command = "copy executable\\GOMC_Serial_GEMC " + full_path_name;
            cout << command <<endl;
            system(command.c_str());
            full_path_name += "/GOMC_Serial_GEMC";
        }
        else if(full_path_name.find("GCMC") != string::npos)
        {
            full_path_name.replace(0, -1, "/", "\\");
            string command = "copy executable\\GOMC_Serial_GCMC " + full_path_name;
            cout << command <<endl;
            system(command.c_str());
            full_path_name += "GOMC_Serial_GCMC";
        }
        else if(full_path_name.find("NVT") != string::npos)
        {
            full_path_name.replace(0, -1, "/", "\\");
            string command = "copy executable\\GOMC_Serial_NVT " + full_path_name;
            cout << command <<endl;
            system(command.c_str());
            full_path_name += "GOMC_Serial_NVT";
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
    listdir(directory_list, "inputs");
    copyexec(directory_list);

    /*vector<string>::iterator iter;
    for(iter=directory_list.begin(); iter!=directory_list.end();iter++)
        cout << *iter << endl;*/
    return 0;
}
