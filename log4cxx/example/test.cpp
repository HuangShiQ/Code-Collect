

#include<log4cxx/logger.h>



#include<log4cxx/propertyconfigurator.h>


#include <string>
using namespace log4cxx;
using namespace std;



int main()


{


	//����log4cxx�������ļ�������ʹ���������ļ�



	PropertyConfigurator::configure("log4cxx.properties");



	//���һ��Logger������ʹ����RootLogger



	LoggerPtr rootLogger = Logger::getRootLogger();



	//����INFO������������



	LOG4CXX_INFO(rootLogger, "����ȷ������");

	string s;
	for (int i = 0; i < 5; i++)
	{


//#ifdef _DEBUG
		if (i != 2)
		{
			LOG4CXX_INFO(rootLogger, "��" + to_string(i) + "���ܹ�����");
		}
		else

		{
			LOG4CXX_ERROR(rootLogger, "��" + to_string(i) + "�δ���");
		}

//#else
//
//
//		LOG4CXX_INFO(rootLogger, "����");
//
//
//#endif
	}


	//rootLogger->info(_T("����ȷ������"));//�������Ǿ仰�����൱

	getchar();
	return 0;



}
