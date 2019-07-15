//Gauss Elimination
#include <iostream>
#include <iomanip>
#include <math.h>
#include <fstream>
#include <stdlib.h>
#include <math.h>
#include <fstream>


using namespace std;

void gauss(double p[], double t[], int n, double x[])
{

    int i,j,k;

    double a[n][n+1];        //declare an array to store the elements of augmented-matrix

    for (i=0;i<n;i++)
    {
        double pro=1;
         for (j=0;j<=n;j++)
         {
            if(j<n)
            {
                a[i][j] = pro;
                pro*=t[i]/(j+1);
            }
            else if(j == n)
            {
                a[i][j] = p[i];

            }

         }
    }

    for (i=0;i<n;i++)                    //Pivotisation
        for (k=i+1;k<n;k++)
            if (abs(a[i][i])<abs(a[k][i]))
                for (j=0;j<=n;j++)
                {
                    double temp=a[i][j];
                    a[i][j]=a[k][j];
                    a[k][j]=temp;
                }

    for (i=0;i<n-1;i++)            //loop to perform the gauss elimination
        for (k=i+1;k<n;k++)
            {
                double t=a[k][i]/a[i][i];
                for (j=0;j<=n;j++)
                    a[k][j]=a[k][j]-t*a[i][j];    //make the elements below the pivot elements equal to zero or elimnate the variables
            }

    for (i=n-1;i>=0;i--)                //back-substitution
    {                        //x is an array whose values correspond to the values of x,y,z..
        x[i]=a[i][n];                //make the variable to be calculated equal to the rhs of the last equation
        for (j=i+1;j<n;j++)
            if (j!=i)            //then subtract all the lhs values except the coefficient of the variable whose value                                   is being calculated
                x[i]=x[i]-a[i][j]*x[j];
        x[i]=x[i]/a[i][i];            //now finally divide the rhs by the coefficient of the variable to be calculated
    }

}

int main()
{
    ifstream infile("test_in.txt");
    ofstream outfile("test_out.txt");
    outfile.precision(0);
    outfile.setf(ios::fixed);
    outfile.setf(ios::showpoint);
    int n;
    cout<<"Enter number of points : - \n";
//    cin>>n;
    infile>>n;
    double a1=25, a2=16.5;

    double st[n], s1[n], s2[n], s3[n], s4[n], s5[n], t[n];

    for(int i=0;i<n;i++)
    {
        double r,theta,p,ro,pi,yaw,time;
    do{
        cout<<"Ensure data entered is \n";
        cout<<"Enter all info for point "<<(i+1)<<" : ";

        cout<<"Enter r:- ";
//        cin>>r;
        infile>>r;
        if(!(r>=(a1-a2) && r<=(a1+a2))){
            cout<<"r of point number "<<i+1<<" is incorrect."<<endl;
            break;
        }
        cout<<endl;

        cout<<"Enter theta:- ";
//        cin>>theta;
        infile>>theta;
        if(!(theta>=0 && theta<=90)){
            cout<<"theta of point number "<<i+1<<" is incorrect."<<endl;
            break;
        }
        cout<<endl;

        cout<<"Enter phi:- ";
//        cin>>p;
        infile>>p;
        cout<<p;
        if(!(p>0 && p<360)){
            cout<<"phi of point number "<<i+1<<" is incorrect."<<endl;
            break;
        }
        cout<<endl;

        cout<<"Enter roll:- ";
//        cin>>ro;
        infile>>ro;
        cout<<ro;
        cout<<endl;

        cout<<"Enter pitch:- ";
        infile>>pi;
        cout<<pi;
        if(!(pi>=0 && pi<=180)){
            cout<<"pitch of point number "<<i+1<<" is incorrect."<<endl;
            break;
        }
        cout<<endl;

        cout<<"Enter yaw:- ";
        infile>>yaw;
        if(!(yaw>=0 && yaw<=180)){
            cout<<"yaw of point number "<<i+1<<" is incorrect."<<endl;
            break;
        }
        cout<<endl;

        cout<<"Enter time:- ";
        infile>>time;
        cout<<endl;

    }while (! (r>=(a1-a2) && r<=(a1+a2) && theta>=0 && theta<=90 && p>0 && p<360 && pi>=0 && pi<=180&& yaw>=0 && yaw<=180 && time>=0));

        double stv, s1v, s2v, s3v, s4v, s5v;

        const double f = 3.141592653589/180.0;

        stv = p;
        s5v = yaw;
        s4v = ro;

        double y = r*cos(f*theta);
        double x = r*sin(f*theta);

        s2v = acos( (x*x + y*y - a1*a1 - a2*a2) / (2*a1*a2) ) / f;

        double thet = atan2(y,x) + atan2( a2*sin(s2v*f) , (a1 + a2*cos(s2v*f)) );
        s1v = 90.0 - (thet/f);

        s3v = pi - (s1v+s2v);

        st[i] = stv;
        s1[i] = s1v;
        s2[i] = s2v;
        s3[i] = s3v;
        s4[i] = s4v;
        s5[i] = s5v;
        t[i] = time;
    }

    double stc[n], s1c[n], s2c[n], s3c[n], s4c[n], s5c[n];

    gauss(st,t,n,stc);
    gauss(s1,t,n,s1c);
    gauss(s2,t,n,s2c);
    gauss(s3,t,n,s3c);
    gauss(s4,t,n,s4c);
    gauss(s5,t,n,s5c);

     for(int i = 0; i<n; i++)
         cout<<stc[i]<<endl;
     cout<<endl;

     for(int i = 0; i<n; i++)
         cout<<s1c[i]<<endl;
     cout<<endl;

     for(int i = 0; i<n; i++)
         cout<<s2c[i]<<endl;
     cout<<endl;

     for(int i = 0; i<n; i++)
         cout<<s3c[i]<<endl;
     cout<<endl;

     for(int i = 0; i<n; i++)
         cout<<s4c[i]<<endl;
     cout<<endl;

     for(int i = 0; i<n; i++)
         cout<<s5c[i]<<endl;
     cout<<endl;

    double tt = t[n-1] - t[0];
    cout<<"Total time: - "<<tt<<endl;

    int nop = ((tt*10) ) + 1;
    cout<<"Number of points : - "<<nop<<endl;

    double stp[nop], s1p[nop], s2p[nop], s3p[nop], s4p[nop], s5p[nop];

    for(int k=0;k<nop;k++)
    {
        stp[k]=0;
        s1p[k]=0;
        s2p[k]=0;
        s3p[k]=0;
        s4p[k]=0;
        s5p[k]=0;
    }

    double i=t[0];
    cout<<"Last time :- "<<t[n-1]<<endl;
    for(int ind = 0; i<=t[n-1] || ind<nop; i+=0.1, ind++)
    {
        double pro=1;

        cout<<"Calculation for t = "<<i<<" started ...\n";

        for(int j=0;j<n;j++)
        {
            stp[ind] += stc[j]*pro;
            s1p[ind] += s1c[j]*pro;
            s2p[ind] += s2c[j]*pro;
            cout<<s2c[j]*pro<<endl<<i/(j+1)<<endl;
            s3p[ind] += s3c[j]*pro;
            s4p[ind] += s4c[j]*pro;
            s5p[ind] += s5c[j]*pro;
            cout<<"intermediate s2p: "<<s2p[ind]<<endl;

            pro*=i/(j+1);
        }
        cout<<"Calculation complete \n\n\n";
    }

    cout<<"\nIntermediate points for st are :- \n";

    for(int i = 0; i<nop; i++)
    {
        cout<<stp[i]<<endl;
    }

    cout<<"\nIntermediate points for s1 are :- \n";

    for(int i = 0; i<(10*tt + 1); i++)
    {
        cout<<s1p[i]<<endl;
    }

    cout<<"\nIntermediate points for s2 are :- \n";

    for(int i = 0; i<(10*tt + 1); i++)
    {
        cout<<s2p[i]<<endl;
    }

    cout<<"\nIntermediate points for s3 are :- \n";

    for(int i = 0; i<(10*tt + 1); i++)
    {
        cout<<s3p[i]<<endl;
    }

    cout<<"\nIntermediate points for s4 are :- \n";

    for(int i = 0; i<(10*tt + 1); i++)
    {
        cout<<s4p[i]<<endl;
    }

    cout<<"\nIntermediate points for s5 are :- \n";

    for(int i = 0; i<(10*tt + 1); i++)
    {
        cout<<s5p[i]<<endl;
    }

 //   outfile<<t[0]<<endl<<t[n-1]<<endl;
 //   outfile<<nop<<endl;


    int s1off = 31, s2off = 1, s3off = 0, s4off = 0, s5off = 0;

    for(int i = 0; i<nop; i++)
    {
        outfile<<stp[i]<<endl;
//        outfile<<s1p[i]+s1off<<endl;
//        outfile<<s2p[i]+s2off<<endl;
//        outfile<<180+s3p[i]+s3off<<endl;
//        outfile<<s4p[i]+s4off<<endl;
//        outfile<<s5p[i]+s5off<<endl;
    }
    return 0;
}
