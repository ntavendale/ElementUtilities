{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at http://www.mozilla.org/MPL/              }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Initial Developer of the Original Code is Matthias            }
{    Ackermann. For other initial contributors, see contributors.txt   }
{    Subsequent portions Copyright Creative IT.                        }
{                                                                      }
{                                                                      }
{**********************************************************************}
unit oamSlimReadWriteLock;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, Types,
  {$IFDEF FPC}
      {$IFDEF Windows}
         WinApi.Windows
      {$ELSE}
         LCLIntf
      {$ENDIF}
   {$ELSE}
      Windows
      {$IFNDEF VER200}, IOUtils{$ENDIF}
   {$ENDIF};

type
  {$ifdef UNIX}
  ToamCriticalSection = class (TCriticalSection);
  {$else}
  ToamCriticalSection = class
  private
    FCS : TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Enter;
    procedure Leave;
    function TryEnter : Boolean;
  end;
  {$endif}

  IMultiReadSingleWrite = interface
    procedure BeginRead;
    function  TryBeginRead : Boolean;
    procedure EndRead;
    procedure BeginWrite;
    function  TryBeginWrite : Boolean;
    procedure EndWrite;
  end;

  TMultiReadSingleWriteState = (mrswUnlocked, mrswReadLock, mrswWriteLock);

  {$ifdef UNIX}{$define SRW_FALLBACK}{$endif}
  ToamSlimReadWriteLock = class (TInterfacedObject, IMultiReadSingleWrite)
  private
    {$ifndef SRW_FALLBACK}
    FSRWLock : Pointer;
    {$else}
    FLock : TdwsCriticalSection;
    {$endif}

  public
    {$ifdef SRW_FALLBACK}
    constructor Create;
    destructor Destroy; override;
    {$endif}

    procedure BeginRead; inline;
    function  TryBeginRead : Boolean; inline;
    procedure EndRead; inline;

    procedure BeginWrite; inline;
    function  TryBeginWrite : Boolean; inline;
    procedure EndWrite; inline;
    //use for diagnostic only
    function State : TMultiReadSingleWriteState;
  end;

{$ifndef SRW_FALLBACK}
procedure AcquireSRWLockExclusive(var SRWLock : Pointer); stdcall; external 'kernel32.dll';
function TryAcquireSRWLockExclusive(var SRWLock : Pointer) : BOOL; stdcall; external 'kernel32.dll';
procedure ReleaseSRWLockExclusive(var SRWLock : Pointer); stdcall; external 'kernel32.dll';

procedure AcquireSRWLockShared(var SRWLock : Pointer); stdcall; external 'kernel32.dll';
function TryAcquireSRWLockShared(var SRWLock : Pointer) : BOOL; stdcall; external 'kernel32.dll';
procedure ReleaseSRWLockShared(var SRWLock : Pointer); stdcall; external 'kernel32.dll';
{$endif}

implementation

{$REGION 'ToamCriticalSection'}
constructor ToamCriticalSection.Create;
begin
   InitializeCriticalSection(FCS);
end;

destructor ToamCriticalSection.Destroy;
begin
   DeleteCriticalSection(FCS);
end;

procedure ToamCriticalSection.Enter;
begin
   EnterCriticalSection(FCS);
end;

procedure ToamCriticalSection.Leave;
begin
   LeaveCriticalSection(FCS);
end;

function ToamCriticalSection.TryEnter : Boolean;
begin
   Result := TryEnterCriticalSection(FCS);
end;
{$ENDREGION}

{$REGION 'ToamSlimReadWriteLock'}
{$ifndef SRW_FALLBACK}
procedure ToamSlimReadWriteLock.BeginRead;
begin
  AcquireSRWLockShared(FSRWLock);
end;

function ToamSlimReadWriteLock.TryBeginRead : Boolean;
begin
  Result:=TryAcquireSRWLockShared(FSRWLock);
end;

procedure ToamSlimReadWriteLock.EndRead;
begin
  ReleaseSRWLockShared(FSRWLock)
end;

procedure ToamSlimReadWriteLock.BeginWrite;
begin
  AcquireSRWLockExclusive(FSRWLock);
end;

function ToamSlimReadWriteLock.TryBeginWrite : Boolean;
begin
  Result := TryAcquireSRWLockExclusive(FSRWLock);
end;

procedure ToamSlimReadWriteLock.EndWrite;
begin
  ReleaseSRWLockExclusive(FSRWLock)
end;

function ToamSlimReadWriteLock.State : TMultiReadSingleWriteState;
begin
  // Attempt to guess the state of the lock without making assumptions
  // about implementation details
  // This is only for diagnosing locking issues
  if TryBeginWrite then
  begin
    EndWrite;
    Result := mrswUnlocked;
  end
  else if TryBeginRead then
  begin
    EndRead;
    Result := mrswReadLock;
  end else
  begin
    Result := mrswWriteLock;
  end;
end;
{$else} // SRW_FALLBACK
constructor ToamSlimReadWriteLock.Create;
begin
  FLock := TdwsCriticalSection.Create;
end;

destructor ToamSlimReadWriteLock.Destroy;
begin
  FLock.Free;
end;

procedure ToamSlimReadWriteLock.BeginRead;
begin
  FLock.Enter;
end;

function ToamSlimReadWriteLock.TryBeginRead : Boolean;
begin
  Result:=FLock.TryEnter;
end;

procedure ToamSlimReadWriteLock.EndRead;
begin
  FLock.Leave;
end;

procedure ToamSlimReadWriteLock.BeginWrite;
begin
  FLock.Enter;
end;

function ToamSlimReadWriteLock.TryBeginWrite : Boolean;
begin
  Result := FLock.TryEnter;
end;

procedure ToamSlimReadWriteLock.EndWrite;
begin
  FLock.Leave;
end;

function ToamSlimReadWriteLock.State : TMultiReadSingleWriteState;
begin
  if FLock.TryEnter then
  begin
    FLock.Leave;
    Result := mrswUnlocked;
  end
  else
    Result := mrswWriteLock;
end;
{$endif}
{$ENDREGION}

end.
