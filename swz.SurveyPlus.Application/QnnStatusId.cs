using System;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Id of a QNN_STATUS
    /// Reifies the concept of an id that represents a response status, so we can pass it around
    /// as a stronger type and add some convenient methods to it. Response status types are stored
    /// in QNN_STATUS table (for which the value of statusId is key) and there are several 'core'
    /// status in SurveyPlus that have well-known ids. 
    /// Instances of StatusId can be created from a Guid or String using the factory methods. They will
    /// only compare and equate with other instances of StatusId. 
    /// Casts to and from Guid have not been provided as the main place you want to do this is when
    /// reading from the DynamicEntity and that still requires a cast to Guid before casting to this (because
    /// DynamicEntity will present the value as Object and we can't add a cast for that!) so to avoid confusion
    /// and requiring you to do QnnStatusId s = (QnnStatusId)(Guid)entity["Status"] which will always be forgotton
    /// in favour of QnnStatusId s = (QnnStatusId)entity["Status"], which will fail at runtime... we will just
    /// require you to use the factory method here. ie:
    /// QnnStatusId s = QnnStatusId.FromGuid((Guid)entity["Status"]);
    /// Its a bit more verbose, but I tried the casting way first and decided this more verbose way will have less mistakes later.
    /// </summary>
    public class QnnStatusId
    {
        //Below are flyweight instances for the CORE SurveyPlus status.
        //Please do not put customer-specific custom status here (they can go in Constants.cs till we find a better place)

        /// <summary>
        /// Id in QNN_STATUS for Pending (PE) A3D01086-40FC-4A7A-BF0C-DE17BDD205FA
        /// </summary>
        public static readonly QnnStatusId Pending = QnnStatusId.FromString("A3D01086-40FC-4A7A-BF0C-DE17BDD205FA");

        /// <summary>
        /// Id in QNN_STATUS for Acknowledged (AC) 19A0C4FF-BE69-4011-A135-3C05A5429616
        /// </summary>
        public static readonly QnnStatusId Acknowledged = QnnStatusId.FromString("19A0C4FF-BE69-4011-A135-3C05A5429616");

        /// <summary>
        /// Id in QNN_STATUS for In-Progress (DE) 0D67932C-62EA-4CD3-A254-0CC63E742C93
        /// </summary>
        public static readonly QnnStatusId InProgress = QnnStatusId.FromString("0D67932C-62EA-4CD3-A254-0CC63E742C93");

        /// <summary>
        /// Id in QNN_STATUS for Submitted (SB) 7C23B23E-23A3-4F04-96EF-89521BABE78D
        /// </summary>
        public static readonly QnnStatusId Submitted = QnnStatusId.FromString("7C23B23E-23A3-4F04-96EF-89521BABE78D");

        /// <summary>
        /// Is in QNN_STATUS for Exempted (EM) 9731DE1D-2B6A-484C-BF10-44F842A3140E
        /// </summary>
        public static readonly QnnStatusId Exempted = QnnStatusId.FromString("9731DE1D-2B6A-484C-BF10-44F842A3140E");

        /// <summary>
        /// Id in QNN_STATUS for Cleared (CL) 129C7781-536D-42F6-ACA4-33A62F2E2C1F
        /// </summary>
        public static readonly QnnStatusId Cleared = QnnStatusId.FromString("129C7781-536D-42F6-ACA4-33A62F2E2C1F");

        /// <summary>
        /// Returns a QnnStatusId for the specified Id in QNN_STATUS table
        /// The Guid may not be EMPTY
        /// </summary>
        /// <param name="statusId">an id in QNN_STATUS</param>
        public static QnnStatusId FromGuid(Guid? statusId)
        {
            if (statusId == null) throw new ArgumentNullException(nameof(statusId));
            return new QnnStatusId((Guid)statusId);
        }

        /// <summary>
        /// Parses the string into a QnnStatusId. A FormatException is thrown if the string is not a
        /// valid Guid, an ArgumentNullException is thrown if it is null. The guid may not be EMPTY.
        /// </summary>
        /// <param name="statusId">a string GUID representing an Id in QNN_STATUS table</param>
        public static QnnStatusId FromString(string statusId)
        {
            if (statusId == null) throw new ArgumentNullException(nameof(statusId));
            try
            {
                return new QnnStatusId(Guid.Parse(statusId));
            }
            catch (FormatException fe)
            {
                throw new FormatException($"Invalid format for {nameof(QnnStatusId)} value", fe);
            }
        }

        public static bool operator == (QnnStatusId lhs, QnnStatusId rhs) => (lhs.Equals(null)) ? (rhs.Equals(null)) : lhs.Equals(rhs);
        public static bool operator != (QnnStatusId lhs, QnnStatusId rhs) => !(lhs == rhs);

        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// A Guid that represents an Id in the SurveyPlus QNN_STATUS table
        /// </summary>
        public Guid Value { get; } //Intended to be immutable, do not add a setter!

        /// <summary>
        /// Is this the core SurveyPlus status of Cleared?
        /// </summary>
        public bool IsCleared { get => this.Equals(Cleared); }


        /// <summary>
        /// Is this the core SurveyPlus status of Pending?
        /// </summary>
        public bool IsPending { get => this.Equals(Pending); }

        /// <summary>
        /// Is this the core SUrveyPlus status of In-Progress?
        /// </summary>
        public bool IsInProgress { get => this.Equals(InProgress); }

        /// <summary>
        /// Is this the core SurveyPlus status of Submitted?
        /// </summary>
        public bool IsSubmitted { get => this.Equals(Submitted); }

        /// <summary>
        /// Is this the SurveyPlus core status of Exempted? 
        /// </summary>
        public bool IsExempted { get => this.Equals(Exempted); }

        public bool IsAcknowledged { get => this.Equals(Acknowledged); }

        private QnnStatusId(Guid id)
        {
            if (Guid.Empty.Equals(id))
                throw new ArgumentOutOfRangeException(nameof(id), "May not be Guid.EMPTY");
            this.Value = id;
        }

        /// <summary>
        /// Returns true if this represents the same row in QNN_STATUS as the one passed in.
        /// WARNING: only compares with another object of same type 
        /// if you pass a Guid or String without casting or converting then it will return false.
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {
            return obj is QnnStatusId that 
                && this.Value.Equals(that.Value);
        }

        /// <summary>
        /// Uses the hashcode of the wrapped Guid
        /// </summary>
        /// <returns></returns>
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }

        /// <summary>
        /// Returns the wrapped Guid in string form
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return Value.ToString();
        }


    }
}
