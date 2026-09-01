using System;
using System.Collections.Generic;

namespace swz.Clover.Core.View
{
    public enum GridSortOrder
    {
        ASC,DESC
    }

    //todo - fix typo, but requires updating all the places refencing this (low priority)
    public class ClienSortItem
    {
        public string Column { get; set; }
        public GridSortOrder Order { get; set; }
    }

    public static class ClientSortExtensions
    {
        public static Order ToORMOrder(this IEnumerable<ClienSortItem> sort)
        {
            Order orderCriteria = Order.Empty;

            if (sort == null)
                return orderCriteria;

            foreach (var gridSortItem in sort)
            {
                switch (gridSortItem.Order)
                {
                    case GridSortOrder.ASC:
                        orderCriteria = orderCriteria.Asc(gridSortItem.Column);
                        break;
                    case GridSortOrder.DESC:
                        orderCriteria = orderCriteria.Desc(gridSortItem.Column);
                        break;
                    default:
                        throw new Exception("Unknown sort order must be asc or desc");
                }
            }
            return orderCriteria;
        }
    }
}