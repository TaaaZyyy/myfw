public without sharing class ul_LockRecordHandler {
    private ul_LockRecordHandler() {}

// ============
//  ロック解除
// ============
    public static void unlock(List<SObject> lockedRecords) {
        Approval.unlock(lockedRecords);
    }

    public static void unlock(SObject lockedRecord) {
        Approval.unlock(lockedRecord);
    }

    public static void unlock(List<Id> lockedRecordIds) {
        Approval.unlock(lockedRecordIds);
    }

    public static void unlock(Id lockedRecordId) {
        Approval.unlock(lockedRecordId);
    }



// ============
//  ロック
// ============
    public static void lock(List<SObject> lockedRecords) {
        Approval.lock(lockedRecords);
    }

    public static void lock(SObject lockedRecord) {
        Approval.lock(lockedRecord);
    }

    public static void lock(List<Id> lockedRecordIds) {
        Approval.lock(lockedRecordIds);
    }

    public static void lock(Id lockedRecordId) {
        Approval.lock(lockedRecordId);
    }


// ============
//  アップデート
// ============
    /**
    * レコード更新ロジック
    *
    * レコードがロックされていた場合は更新後に再度ロックを掛ける
    */
    public static void update(SObject obj) {
        SavePoint sp = Database.setSavePoint();
        try {
            if (Approval.isLocked(obj)) {
                Approval.unlock(obj);
                update obj;
                Approval.lock(obj);
            } else {
                update obj;
            }
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }


    /**
    * レコード更新ロジック
    *
    * レコードがロックされていた場合は更新後に再度ロックを掛ける
    */
    public static void update(List<SObject> objList) {
        SavePoint sp = Database.setSavePoint();
        try {
            List<Id> lockedRecordIds = new List<Id>();
            for (SObject obj : objList) {
                if (Approval.isLocked(obj)) {
                    lockedRecordIds.add(obj.Id);
                }
            }

            // ロックされているレコードの場合、一時的にロック解除する
            if (!lockedRecordIds.isEmpty()) { unlock(lockedRecordIds); }
            update objList;
            if (!lockedRecordIds.isEmpty()) { lock(lockedRecordIds); }
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }
}