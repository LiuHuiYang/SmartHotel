 
-- 电视频道
CREATE TABLE IF NOT EXISTS TVChannel (

    tvID INTEGER NOT NULL DEFAULT 0,
    channelID INTEGER NOT NULL DEFAULT 0,
    groupID INTEGER NOT NULL DEFAULT 0,

    channelName TEXT NOT NULL DEFAULT 'channel',
    iconName TEXT NOT NULL DEFAULT 'channel_icon',

    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,
    channelIRCode INTEGER NOT NULL DEFAULT 0,

    delayTime INTEGER NOT NULL DEFAULT 100
);

-- 电视频道分组
CREATE TABLE IF NOT EXISTS TVChannelGroup (

    tvID INTEGER NOT NULL DEFAULT 0,
    groupID INTEGER NOT NULL DEFAULT 0,
    groupName TEXT NOT NULL DEFAULT 'channel group'
);

-- 电视

CREATE TABLE IF NOT EXISTS TV (

    tvID INTEGER NOT NULL DEFAULT 0,
    tvName TEXT NOT NULL DEFAULT 'tv',

    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,

    turnOn INTEGER NOT NULL DEFAULT 0,
    turnOff INTEGER NOT NULL DEFAULT 0,

    muteOn INTEGER NOT NULL DEFAULT 0,
    muteOff INTEGER NOT NULL DEFAULT 0,

    volumeUp INTEGER NOT NULL DEFAULT 0,
    volumeDown INTEGER NOT NULL DEFAULT 0,

    channelUp INTEGER NOT NULL DEFAULT 0,
    channelDown INTEGER NOT NULL DEFAULT 0,

    sure INTEGER NOT NULL DEFAULT 0,

    number0 INTEGER NOT NULL DEFAULT 0,
    number1 INTEGER NOT NULL DEFAULT 0,
    number2 INTEGER NOT NULL DEFAULT 0,
    number3 INTEGER NOT NULL DEFAULT 0,
    number4 INTEGER NOT NULL DEFAULT 0,
    number5 INTEGER NOT NULL DEFAULT 0,
    number6 INTEGER NOT NULL DEFAULT 0,
    number7 INTEGER NOT NULL DEFAULT 0,
    number8 INTEGER NOT NULL DEFAULT 0,
    number9 INTEGER NOT NULL DEFAULT 0
    
);

-- 宏定义
CREATE TABLE IF NOT EXISTS Macro (

    macroID INTEGER NOT NULL DEFAULT 0,
    macroName TEXT NOT NULL DEFAULT 'Scene',
    macroIconName TEXT NOT NULL DEFAULT 'Scene_1'
);

-- 宏定义的操作命令
CREATE TABLE IF NOT EXISTS MacroCommand (

    macroCommandID INTEGER NOT NULL DEFAULT 0,
    macroID INTEGER NOT NULL DEFAULT 0,

    remark TEXT NOT NULL DEFAULT 'macro command',
    commandType INTEGER NOT NULL DEFAULT 0,
    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,

    parameter1 INTEGER NOT NULL DEFAULT 0,
    parameter2 INTEGER NOT NULL DEFAULT 0,
    parameter3 INTEGER NOT NULL DEFAULT 0,
    parameter4 INTEGER NOT NULL DEFAULT 0,
    parameter5 INTEGER NOT NULL DEFAULT 0,
    parameter6 INTEGER NOT NULL DEFAULT 0,
    parameter7 INTEGER NOT NULL DEFAULT 0,
    parameter8 INTEGER NOT NULL DEFAULT 0,
    delayTime INTEGER NOT NULL DEFAULT 100
);

-- 图片数据
/*
CREATE TABLE IF NOT EXISTS iconData (

);
*/

-- 灯泡
CREATE TABLE IF NOT EXISTS Light (

    lightID INTEGER NOT NULL DEFAULT 0,
    lightName TEXT NOT NULL DEFAULT 'light',

    lightType INTEGER NOT NULL DEFAULT 0,

    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,
    channelNo  INTEGER NOT NULL DEFAULT 0
);

-- 空调
CREATE TABLE IF NOT EXISTS AirConditioner (

    acID INTEGER NOT NULL DEFAULT 0,
    acName TEXT NOT NULL DEFAULT 'ac',

    acType INTEGER NOT NULL DEFAULT 0,
    acNumber INTEGER NOT NULL DEFAULT 0,

    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,
    channelNo  INTEGER NOT NULL DEFAULT 0
);

-- 窗帘
CREATE TABLE IF NOT EXISTS Curtains (

    curtainID INTEGER NOT NULL DEFAULT 0,
    curtainName TEXT NOT NULL DEFAULT 'curtain',

    curtainType INTEGER NOT NULL DEFAULT 0,

    subnetID INTEGER NOT NULL DEFAULT 0,
    deviceID INTEGER NOT NULL DEFAULT 0,

    openChannel INTEGER DEFAULT 0,
    closeChannel INTEGER DEFAULT 0,
    stopChannel INTEGER NOT NULL DEFAULT 0,

    switchIDforOpen INTEGER NOT NULL DEFAULT 0,
    switchIDforClose INTEGER NOT NULL DEFAULT 0,
    switchIDforStop INTEGER NOT NULL DEFAULT 0
);
