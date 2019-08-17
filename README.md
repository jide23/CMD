
>- @ProjectFile   ：README
>- @Author        ：Mr. Ji 
>- @Date          ：2019/08/16
>- @Description   ：CMD function required for operation and maintenance
>- 高山仰止,景行行止. 虽不能至,心向往之. 
>- [参考文档](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/reg)
## CMD_Plug Content Include
> - 【1】电脑重命名
> - 【2】获取系统信息
> - 【3】创建新用户
> - 【4】删除老用户
> - 【5】通过IP获取其用户名
> - 【6】映射
> - 【7】注册表
> - 【Q】退出
## Set File Permission
###### For Example:
###### HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run [17 20]
<!-- 即文件拥有权限： System 完全访问，Administrators 读、写、执行访问 -->
    1  - Administrators 完全访问
    2  - Administrators 只读访问
    3  - Administrators 读和写入访问
    4  - Administrators 读、写入、删除访问
    5  - Creator 完全访问
    6  - Creator 读和写入访问
    7  - everyone 完全访问
    8  - everyone 只读访问
    9  - everyone 读和写入访问
    10 - everyone 读、写入、删除访问
    11 - Power Users 完全访问
    12 - Power Users 读和写入访问
    13 - Power Users 读、写入、删除访问
    14 - System Operators 完全访问
    15 - System Operators 读和写入访问
    16 - System Operators 读、写入、删除访问
    17 - System 完全访问
    18 - System 读和写入访问
    19 - System 只读访问
    20 - Administrators 读、写、执行访问
    21 - Interactive User 完全访问
    22 - Interactive User 读和写入访问
    23 - Interactive User 读、写入、删除访问
    
######   注册表 BB_.reg 修改是否成功：
<!-- Whether the modification is completed -->
######  即将导出注册表 reg\BB_.reg 中键F的值替换为 reg\AA_1F4.reg 中键F的值