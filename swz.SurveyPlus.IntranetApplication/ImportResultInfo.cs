using System;

namespace swz.SurveyPlus.IntranetApplication
{
    //Used by SampleListApplication and TrkListApplication

    [Serializable]   //TODO - where does this get serialised? (hangfire?) <-- have seen it in returns to clientside
    public class ImportResultInfo
    {
        private string _ErrField;
        private string _ErrMsg;

        private int _RowNo = -1;  
        private string _UID;

        /// <summary>
        /// row numbers are 1 based, not 0 based
        /// </summary>
        public int RowNo
        {
            get => _RowNo;
            set => _RowNo = value;
        }

        public string UID
        {
            get => _UID;
            set => _UID = value;
        }

        public string ErrField
        {
            get => _ErrField;
            set => _ErrField = value;
        }

        public string ErrMsg
        {
            get => _ErrMsg;
            set => _ErrMsg = value;
        }

        public ImportResultInfo(
            int rowNumber, 
            string uid, 
            string errField, 
            string errMsg)
        {
            if (rowNumber < 1) throw new ArgumentException("Must be >=1 (1-based row index)", nameof(rowNumber));
            if (uid==null) throw new ArgumentNullException(nameof(uid)); //use ""if unknown, but shouldn't be null
            if (string.IsNullOrEmpty(errField)) throw new ArgumentException("Must be specified", nameof(errField));
            if (string.IsNullOrEmpty(errMsg)) throw new ArgumentException("Must be specified", nameof(errMsg));
            this.RowNo = rowNumber;
            this.UID = uid;
            this.ErrField = errField;
            this.ErrMsg = errMsg;
        }

        public ImportResultInfo()
        {
            ;
        }
    }
}