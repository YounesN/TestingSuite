#include <iostream>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <vector>

using namespace std;

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
    if(!directory_exists("executable"))
    {
        cout << "Directory \"executable\" does not exists.\nMake sure you copy your executables into the \"executable\" folder and then run this program.\n";
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

    vector<string>::iterator iter;
    for(iter=directory_list.begin(); iter!=directory_list.end();iter++)
        cout << *iter << endl;
    return 0;
}
