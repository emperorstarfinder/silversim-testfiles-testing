/*-----------------------------------------------------------------------
変数
-------------------------------------------------------------------------*/

// 再生するアニメーション
string gAnime = "pose";

// 渡すアイテム一覧
list gGiveItem = [];

// 装着時の回転
vector gAttachV = <3.04999, 12.00000, 341.35001>;

// Rez時の回転
vector gRezV = <0.00000, 0.00000, 0.00000>;

/*-----------------------------------------------------------------------
ユーザー関数
-------------------------------------------------------------------------*/

// 渡すアイテムのリストを作成
ufGiveItem () {
    string n = "";
    integer i = 0;
    integer c = 0;
    gGiveItem = [];

    c = llGetInventoryNumber(INVENTORY_ALL);
    for( i=0; i < c; i++ ) {
        n = llGetInventoryName(INVENTORY_ALL,i);
        if( n != llGetScriptName() && n != gAnime ){
            gGiveItem += n;
        }
    }
}

// 言語別開封メッセージ
ufMes(){
    string lang = llGetAgentLanguage(llGetOwner());
    if(lang == ""){
        lang = "en-us";
    }
    if(lang=="ja") {
        llOwnerSay("タッチで開封出来ます。");
    } else {
        llOwnerSay("can open it with touch.");
    }
}

/*-----------------------------------------------------------------------
スクリプト
-------------------------------------------------------------------------*/

default
{
    state_entry()
    {
        ufGiveItem();
    }

    changed(integer change)
    {
        if( change & CHANGED_LINK || change & CHANGED_INVENTORY || change & CHANGED_OWNER ){
            ufGiveItem();
        }
    }

    attach(key id)
    {
        if( id != NULL_KEY ){
            llRequestPermissions( id, PERMISSION_TRIGGER_ANIMATION );
        }
    }

    run_time_permissions(integer perm)
    {
        if( PERMISSION_TRIGGER_ANIMATION & perm ){
            llSetLocalRot( llEuler2Rot( gAttachV*DEG_TO_RAD ) );
            llStartAnimation( gAnime );
        }
    }

    on_rez(integer start_param)
    {
        llSetRot( llEuler2Rot( gRezV*DEG_TO_RAD ) );
        ufMes();
    }

    touch_start(integer num_detected)
    {
        key id = llGetOwner();

        if( llDetectedKey(0) == id ){
            string folder=llGetObjectName();
            llGiveInventoryList(id,folder,gGiveItem);
        }
    }
}