using System;

namespace swz.Clover.Core.ORM
{
    internal class DynamicPropertyChangedEventArgs : EventArgs
    {
        public object Id { get; set; }

        public object OldValue { get; set; }

        public object NewValue { get; set; }

        public string PropertyName { get; set; }
    }
}
