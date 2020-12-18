{******************************************************************}
{                                                       	   }
{       Borland Delphi Runtime Library                  	   }
{       Process Status API interface unit                          }
{ 								   }
{ Portions created by Microsoft are 				   }
{ Copyright (C) 1995-1999 Microsoft Corporation. 		   }
{ All Rights Reserved. 						   }
{ 								   }
{ The original file is: psapi.h, released June 2000. 	           }
{ The original Pascal code is: PsApi.pas, released December 2000   }
{ The initial developer of the Pascal code is Marcel van Brakel    }
{ (brakelm@bart.nl).                      			   }
{ 								   }
{ Portions created by Marcel van Brakel are			   }
{ Copyright (C) 1999 Marcel van Brakel.				   }
{ 								   }
{ Obtained through:                               	           }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{								   }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{								   }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                   }
{                                                                  }
{ Software distributed under the License is distributed on an 	   }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License. 			   }
{ 								   }
{******************************************************************}

unit PsApi;

{$WEAKPACKAGEUNIT}

{$HPPEMIT ''}
{$HPPEMIT '#include <psapi.h>'}
{$HPPEMIT ''}

{$I WINDEFINES.INC}

interface

uses
  WinType;

function EnumProcesses(lpidProcess: LPDWORD; cb: DWORD; var cbNeeded: DWORD): BOOL; stdcall;
{$EXTERNALSYM EnumProcesses}

function EnumProcessModules(hProcess: HANDLE; lphModule: PHMODULE; cb: DWORD;
  var lpcbNeeded: DWORD): BOOL; stdcall;
{$EXTERNALSYM EnumProcessModules}

function GetModuleBaseNameA(hProcess: HANDLE; hModule: HMODULE; lpBaseName: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleBaseNameA}
function GetModuleBaseNameW(hProcess: HANDLE; hModule: HMODULE; lpBaseName: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleBaseNameW}

{$IFDEF UNICODE}
function GetModuleBaseName(hProcess: HANDLE; hModule: HMODULE; lpBaseName: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleBaseName}
{$ELSE}
function GetModuleBaseName(hProcess: HANDLE; hModule: HMODULE; lpBaseName: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleBaseName}
{$ENDIF}

function GetModuleFileNameExA(hProcess: HANDLE; hModule: HMODULE; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleFileNameExA}
function GetModuleFileNameExW(hProcess: HANDLE; hModule: HMODULE; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleFileNameExW}

{$IFDEF UNICODE}
function GetModuleFileNameEx(hProcess: HANDLE; hModule: HMODULE; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleFileNameEx}
{$ELSE}
function GetModuleFileNameEx(hProcess: HANDLE; hModule: HMODULE; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetModuleFileNameEx}
{$ENDIF}

type
  LPMODULEINFO = ^MODULEINFO;
  {$EXTERNALSYM LPMODULEINFO}
  _MODULEINFO = packed record
    lpBaseOfDll: LPVOID;
    SizeOfImage: DWORD;
    EntryPoint: LPVOID;
  end;
  {$EXTERNALSYM _MODULEINFO}
  MODULEINFO = _MODULEINFO;
  {$EXTERNALSYM MODULEINFO}
  TModuleInfo = MODULEINFO;
  PModuleInfo = LPMODULEINFO;

function GetModuleInformation(hProcess: HANDLE; hModule: HMODULE;
  var lpmodinfo: MODULEINFO; cb: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetModuleInformation}

function EmptyWorkingSet(hProcess: HANDLE): BOOL; stdcall;
{$EXTERNALSYM EmptyWorkingSet}

function QueryWorkingSet(hProcess: HANDLE; pv: PVOID; cb: DWORD): BOOL; stdcall;
{$EXTERNALSYM QueryWorkingSet}

function InitializeProcessForWsWatch(hProcess: HANDLE): BOOL; stdcall;
{$EXTERNALSYM InitializeProcessForWsWatch}

type
  PPSAPI_WS_WATCH_INFORMATION = ^PSAPI_WS_WATCH_INFORMATION;
  {$EXTERNALSYM PPSAPI_WS_WATCH_INFORMATION}
  _PSAPI_WS_WATCH_INFORMATION = packed record
    FaultingPc: LPVOID;
    FaultingVa: LPVOID;
  end;
  {$EXTERNALSYM _PSAPI_WS_WATCH_INFORMATION}
  PSAPI_WS_WATCH_INFORMATION = _PSAPI_WS_WATCH_INFORMATION;
  {$EXTERNALSYM PSAPI_WS_WATCH_INFORMATION}
  TPsApiWsWatchInformation = PSAPI_WS_WATCH_INFORMATION;
  PPsApiWsWatchInformation = PPSAPI_WS_WATCH_INFORMATION;

function GetWsChanges(hProcess: HANDLE; var lpWatchInfo: PSAPI_WS_WATCH_INFORMATION;
  cb: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetWsChanges}

function GetMappedFileNameW(hProcess: HANDLE; lpv: LPVOID; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetMappedFileNameW}
function GetMappedFileNameA(hProcess: HANDLE; lpv: LPVOID; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetMappedFileNameA}

{$IFDEF UNICODE}
function GetMappedFileName(hProcess: HANDLE; lpv: LPVOID; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetMappedFileName}
{$ELSE}
function GetMappedFileName(hProcess: HANDLE; lpv: LPVOID; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetMappedFileName}
{$ENDIF}

function EnumDeviceDrivers(lpImageBase: LPLPVOID; cb: DWORD; var lpcbNeeded: DWORD): BOOL; stdcall;
{$EXTERNALSYM EnumDeviceDrivers}

function GetDeviceDriverBaseNameA(ImageBase: LPVOID; lpBaseName: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverBaseNameA}
function GetDeviceDriverBaseNameW(ImageBase: LPVOID; lpBaseName: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverBaseNameW}

{$IFDEF UNICODE}
function GetDeviceDriverBaseName(ImageBase: LPVOID; lpBaseName: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverBaseName}
{$ELSE}
function GetDeviceDriverBaseName(ImageBase: LPVOID; lpBaseName: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverBaseName}
{$ENDIF}

function GetDeviceDriverFileNameA(ImageBase: LPVOID; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverFileNameA}
function GetDeviceDriverFileNameW(ImageBase: LPVOID; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverFileNameW}

{$IFDEF UNICODE}
function GetDeviceDriverFileName(ImageBase: LPVOID; lpFilename: LPWSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverFileName}
{$ELSE}
function GetDeviceDriverFileName(ImageBase: LPVOID; lpFilename: LPSTR;
  nSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetDeviceDriverFileName}
{$ENDIF}

// Structure for GetProcessMemoryInfo()

type
  PPROCESS_MEMORY_COUNTERS = ^PROCESS_MEMORY_COUNTERS;
  {$EXTERNALSYM PPROCESS_MEMORY_COUNTERS}
  _PROCESS_MEMORY_COUNTERS = packed record
    cb: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: SIZE_T;
    WorkingSetSize: SIZE_T;
    QuotaPeakPagedPoolUsage: SIZE_T;
    QuotaPagedPoolUsage: SIZE_T;
    QuotaPeakNonPagedPoolUsage: SIZE_T;
    QuotaNonPagedPoolUsage: SIZE_T;
    PagefileUsage: SIZE_T;
    PeakPagefileUsage: SIZE_T;
  end;
  {$EXTERNALSYM _PROCESS_MEMORY_COUNTERS}
  PROCESS_MEMORY_COUNTERS = _PROCESS_MEMORY_COUNTERS;
  {$EXTERNALSYM PROCESS_MEMORY_COUNTERS}
  TProcessMemoryCounters = PROCESS_MEMORY_COUNTERS;
  PProcessMemoryCounters = PPROCESS_MEMORY_COUNTERS;

function GetProcessMemoryInfo(Process: HANDLE;
  var ppsmemCounters: PROCESS_MEMORY_COUNTERS; cb: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetProcessMemoryInfo}

implementation

const
  PsapiLib = 'psapi.dll';

function EnumProcesses; external PsapiLib name 'EnumProcesses';
function EnumProcessModules; external PsapiLib name 'EnumProcessModules';
function GetModuleBaseNameA; external PsapiLib name 'GetModuleBaseNameA';
function GetModuleBaseNameW; external PsapiLib name 'GetModuleBaseNameW';
{$IFDEF UNICODE}
function GetModuleBaseName; external PsapiLib name 'GetModuleBaseNameW';
{$ELSE}
function GetModuleBaseName; external PsapiLib name 'GetModuleBaseNameA';
{$ENDIF}
function GetModuleFileNameExA; external PsapiLib name 'GetModuleFileNameExA';
function GetModuleFileNameExW; external PsapiLib name 'GetModuleFileNameExW';
{$IFDEF UNICODE}
function GetModuleFileNameEx; external PsapiLib name 'GetModuleFileNameExW';
{$ELSE}
function GetModuleFileNameEx; external PsapiLib name 'GetModuleFileNameExA';
{$ENDIF}
function GetModuleInformation; external PsapiLib name 'GetModuleInformation';
function EmptyWorkingSet; external PsapiLib name 'EmptyWorkingSet';
function QueryWorkingSet; external PsapiLib name 'QueryWorkingSet';
function InitializeProcessForWsWatch; external PsapiLib name 'InitializeProcessForWsWatch';
function GetWsChanges; external PsapiLib name 'GetWsChanges';
function GetMappedFileNameW; external PsapiLib name 'GetMappedFileNameW';
function GetMappedFileNameA; external PsapiLib name 'GetMappedFileNameA';
{$IFDEF UNICODE}
function GetMappedFileName; external PsapiLib name 'GetMappedFileNameW';
{$ELSE}
function GetMappedFileName; external PsapiLib name 'GetMappedFileNameA';
{$ENDIF}
function EnumDeviceDrivers; external PsapiLib name 'EnumDeviceDrivers';
function GetDeviceDriverBaseNameA; external PsapiLib name 'GetDeviceDriverBaseNameA';
function GetDeviceDriverBaseNameW; external PsapiLib name 'GetDeviceDriverBaseNameW';
{$IFDEF UNICODE}
function GetDeviceDriverBaseName; external PsapiLib name 'GetDeviceDriverBaseNameW';
{$ELSE}
function GetDeviceDriverBaseName; external PsapiLib name 'GetDeviceDriverBaseNameA';
{$ENDIF}
function GetDeviceDriverFileNameA; external PsapiLib name 'GetDeviceDriverFileNameA';
function GetDeviceDriverFileNameW; external PsapiLib name 'GetDeviceDriverFileNameW';
{$IFDEF UNICODE}
function GetDeviceDriverFileName; external PsapiLib name 'GetDeviceDriverFileNameW';
{$ELSE}
function GetDeviceDriverFileName; external PsapiLib name 'GetDeviceDriverFileNameA';
{$ENDIF}
function GetProcessMemoryInfo; external PsapiLib name 'GetProcessMemoryInfo';

