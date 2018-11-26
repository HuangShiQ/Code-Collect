

#include<log4cxx/logger.h>



#include<log4cxx/propertyconfigurator.h>


#include <string>
using namespace log4cxx;
using namespace std;



int main()


{


	//加载log4cxx的配置文件，这里使用了属性文件



	PropertyConfigurator::configure("log4cxx.properties");



	//获得一个Logger，这里使用了RootLogger



	LoggerPtr rootLogger = Logger::getRootLogger();



	//发出INFO级别的输出请求



	LOG4CXX_INFO(rootLogger, "它的确工作了");

	string s;
	for (int i = 0; i < 5; i++)
	{


//#ifdef _DEBUG
		if (i != 2)
		{
			LOG4CXX_INFO(rootLogger, "第" + to_string(i) + "次能够调试");
		}
		else

		{
			LOG4CXX_ERROR(rootLogger, "第" + to_string(i) + "次错误");
		}

//#else
//
//
//		LOG4CXX_INFO(rootLogger, "正常");
//
//
//#endif
	}


	//rootLogger->info(_T("它的确工作了"));//与上面那句话功能相当

	getchar();
	return 0;



}
